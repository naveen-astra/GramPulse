import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grampulse/features/auth/domain/services/auth_service.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc() : super(OtpInitial()) {
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<StartTimerEvent>(_onStartTimer);
    on<TimerTickEvent>(_onTimerTick);
  }

  Timer? _timer;
  static const int timerDuration = 45;

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpSubmitting());
    
    try {
      final authService = AuthService();
      final success = await authService.verifyOTPAndSignIn(event.otp);
      
      if (success) {
        authService.setAuthenticationInProgress(phoneNumber: event.phoneNumber);
        emit(OtpVerified());
      } else {
        emit(OtpError(message: 'Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(OtpError(message: e.toString()));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpResending());
    
    try {
      print('DEBUG: Resending OTP for phone number: ${event.phoneNumber}');
      
      final authService = AuthService();
      
      // Format phone number to include country code if not already present
      String formattedPhoneNumber = event.phoneNumber;
      if (!event.phoneNumber.startsWith('+91')) {
        formattedPhoneNumber = '+91${event.phoneNumber}';
      }
      
      await authService.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        onCodeSent: (String verificationId) {
          print('DEBUG: OTP resent successfully');
          emit(OtpInitial());
          add(const StartTimerEvent());
        },
        onError: (String error) {
          print('DEBUG: Failed to resend OTP: $error');
          emit(OtpError(message: 'Failed to resend OTP: $error'));
        },
      );
    } catch (e) {
      print('DEBUG: Exception while resending OTP: $e');
      emit(OtpError(message: e.toString()));
    }
  }
  
  Future<void> _onStartTimer(
    StartTimerEvent event,
    Emitter<OtpVerificationState> emit,
  ) async {
    _cancelTimer();
    
    emit(OtpTimerRunning(timeRemaining: timerDuration));
    
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => add(TimerTickEvent(timeRemaining: timerDuration - timer.tick)),
    );
  }
  
  void _onTimerTick(
    TimerTickEvent event,
    Emitter<OtpVerificationState> emit,
  ) {
    if (event.timeRemaining > 0) {
      emit(OtpTimerRunning(timeRemaining: event.timeRemaining));
    } else {
      _cancelTimer();
      emit(OtpTimerCompleted());
    }
  }
  
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
  
  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}

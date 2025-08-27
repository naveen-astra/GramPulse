import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grampulse/features/auth/domain/services/auth_service.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final AuthService _authService = AuthService();

  PhoneAuthBloc() : super(PhoneAuthInitial()) {
    on<RequestOtpEvent>(_onRequestOtp);
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(PhoneAuthLoading());
    print('DEBUG: PhoneAuthBloc state changed to: PhoneAuthLoading');
    
    try {
      // Format phone number to include country code if not already present
      String formattedPhoneNumber = event.phoneNumber;
      if (!event.phoneNumber.startsWith('+91')) {
        formattedPhoneNumber = '+91${event.phoneNumber}';
      }
      
      print('DEBUG: PhoneAuthBloc requesting OTP for: $formattedPhoneNumber');
      
      // Simple boolean to track completion
      bool hasCompleted = false;
      
      // Set up timeout
      final timeoutTimer = Timer(const Duration(seconds: 30), () {
        if (!hasCompleted) {
          hasCompleted = true;
          print('DEBUG: PhoneAuthBloc request timed out after 30 seconds');
          if (!emit.isDone) {
            emit(PhoneAuthFailure(error: 'Request timed out. Please check your internet connection and try again.'));
          }
        }
      });
      
      // Call Firebase auth with proper callbacks
      await _authService.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        onCodeSent: (String verificationId) {
          timeoutTimer.cancel();
          if (!hasCompleted) {
            hasCompleted = true;
            print('DEBUG: PhoneAuthBloc received onCodeSent callback');
            print('DEBUG: Emitting PhoneAuthSuccess with phoneNumber: ${event.phoneNumber}');
            if (!emit.isDone) {
              emit(PhoneAuthSuccess(phoneNumber: event.phoneNumber));
              print('DEBUG: PhoneAuthSuccess state emitted successfully');
            }
          }
        },
        onError: (String error) {
          timeoutTimer.cancel();
          if (!hasCompleted) {
            hasCompleted = true;
            print('DEBUG: PhoneAuthBloc received onError callback: $error');
            if (!emit.isDone) {
              emit(PhoneAuthFailure(error: error));
            }
          }
        },
      );
      
    } catch (e) {
      print('DEBUG: PhoneAuthBloc exception: $e');
      if (!emit.isDone) {
        emit(PhoneAuthFailure(error: e.toString()));
      }
    }
  }
}

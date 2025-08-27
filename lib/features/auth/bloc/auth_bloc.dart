import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/core/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<RequestOtp>(_onRequestOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<CompleteProfile>(_onCompleteProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        final response = await _authService.getCurrentUser();
        if (response.success && response.data != null) {
          emit(Authenticated(response.data!, isProfileComplete: response.data!.isProfileComplete));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onRequestOtp(RequestOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.requestOtp(event.phone);
      if (response.success) {
        emit(OtpRequested(event.phone));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.verifyOtp(event.phone, event.otp);
      if (response.success && response.data != null) {
        final user = response.data!;
        emit(Authenticated(user, isProfileComplete: user.isProfileComplete));
      } else {
        emit(OtpVerificationFailed(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCompleteProfile(CompleteProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authService.completeProfile(
        name: event.name,
        role: event.role,
        email: event.email,
      );
      if (response.success && response.data != null) {
        emit(Authenticated(response.data!, isProfileComplete: true));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await _authService.logout();
    emit(Unauthenticated());
  }
}

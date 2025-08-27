import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class RequestOtp extends AuthEvent {
  final String phone;

  RequestOtp(this.phone);

  @override
  List<Object> get props => [phone];
}

class VerifyOtp extends AuthEvent {
  final String phone;
  final String otp;

  VerifyOtp(this.phone, this.otp);

  @override
  List<Object> get props => [phone, otp];
}

class CompleteProfile extends AuthEvent {
  final String name;
  final String role;
  final String? email;
  final File? profilePicture;

  CompleteProfile({
    required this.name,
    required this.role,
    this.email,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [name, role, email, profilePicture];
}

class Logout extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpRequested extends AuthState {
  final String phone;

  OtpRequested(this.phone);

  @override
  List<Object> get props => [phone];
}

class OtpVerificationFailed extends AuthState {
  final String message;

  OtpVerificationFailed(this.message);

  @override
  List<Object> get props => [message];
}

class Authenticated extends AuthState {
  final User user;
  final bool isProfileComplete;

  Authenticated(this.user, {this.isProfileComplete = false});

  @override
  List<Object> get props => [user, isProfileComplete];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileUpdateSuccess extends AuthState {
  final User user;

  ProfileUpdateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileUpdateFailure extends AuthState {
  final String message;

  ProfileUpdateFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();
  
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<RequestOtp>(_onRequestOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<CompleteProfile>(_onCompleteProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (isAuthenticated) {
        final response = await _authService.getCurrentUser();
        if (response.success && response.data != null) {
          final user = response.data!;
          emit(Authenticated(
            user,
            isProfileComplete: user.isProfileComplete,
          ));
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

  Future<void> _onRequestOtp(
    RequestOtp event,
    Emitter<AuthState> emit,
  ) async {
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

  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authService.verifyOtp(event.phone, event.otp);
      if (response.success && response.data != null) {
        final user = response.data!;
        emit(Authenticated(
          user,
          isProfileComplete: user.isProfileComplete,
        ));
      } else {
        emit(OtpVerificationFailed(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCompleteProfile(
    CompleteProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authService.completeProfile(
        name: event.name,
        role: event.role,
        email: event.email,
        profilePicture: event.profilePicture,
      );
      
      if (response.success && response.data != null) {
        emit(Authenticated(
          response.data!,
          isProfileComplete: true,
        ));
      } else {
        emit(ProfileUpdateFailure(response.message));
      }
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authService.logout();
    emit(Unauthenticated());
  }
}

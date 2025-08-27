abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpRequested extends AuthState {
  final String phone;
  OtpRequested(this.phone);
}

class OtpVerificationFailed extends AuthState {
  final String message;
  OtpVerificationFailed(this.message);
}

class Authenticated extends AuthState {
  final dynamic user; // Use dynamic for now to avoid User import issues
  final bool isProfileComplete;
  Authenticated(this.user, {required this.isProfileComplete});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

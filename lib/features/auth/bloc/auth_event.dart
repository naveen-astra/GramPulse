abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class RequestOtp extends AuthEvent {
  final String phone;
  RequestOtp(this.phone);
}

class VerifyOtp extends AuthEvent {
  final String phone;
  final String otp;
  VerifyOtp(this.phone, this.otp);
}

class CompleteProfile extends AuthEvent {
  final String name;
  final String role;
  final String? email;
  CompleteProfile({required this.name, required this.role, this.email});
}

class Logout extends AuthEvent {}

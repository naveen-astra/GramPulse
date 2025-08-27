import 'package:equatable/equatable.dart';

class PhoneAuthState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? verificationId;
  final bool isCodeSent;
  final bool isVerified;
  final String? phoneNumber;

  const PhoneAuthState({
    this.isLoading = false,
    this.error,
    this.verificationId,
    this.isCodeSent = false,
    this.isVerified = false,
    this.phoneNumber,
  });

  PhoneAuthState copyWith({
    bool? isLoading,
    String? error,
    String? verificationId,
    bool? isCodeSent,
    bool? isVerified,
    String? phoneNumber,
  }) {
    return PhoneAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isVerified: isVerified ?? this.isVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        verificationId,
        isCodeSent,
        isVerified,
        phoneNumber,
      ];
}

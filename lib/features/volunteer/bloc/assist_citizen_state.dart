import 'package:equatable/equatable.dart';
import 'package:grampulse/features/volunteer/models/citizen_model.dart';

abstract class AssistCitizenState extends Equatable {
  const AssistCitizenState();

  @override
  List<Object?> get props => [];
}

class InitialState extends AssistCitizenState {}

class LoadingState extends AssistCitizenState {}

class ValidatingState extends AssistCitizenState {}

class ReadyState extends AssistCitizenState {
  final String phone;
  final String name;
  final List<CitizenModel> recentCitizens;
  final bool isPhoneValid;
  final bool isNameValid;
  final bool hasConsent;

  const ReadyState({
    required this.phone,
    required this.name,
    required this.recentCitizens,
    required this.isPhoneValid,
    required this.isNameValid,
    required this.hasConsent,
  });

  ReadyState copyWith({
    String? phone,
    String? name,
    List<CitizenModel>? recentCitizens,
    bool? isPhoneValid,
    bool? isNameValid,
    bool? hasConsent,
  }) {
    return ReadyState(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      recentCitizens: recentCitizens ?? this.recentCitizens,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      isNameValid: isNameValid ?? this.isNameValid,
      hasConsent: hasConsent ?? this.hasConsent,
    );
  }

  @override
  List<Object?> get props => [
        phone,
        name,
        recentCitizens,
        isPhoneValid,
        isNameValid,
        hasConsent,
      ];
}

class ErrorState extends AssistCitizenState {
  final String message;
  final String? phoneError;
  final String? nameError;

  const ErrorState({
    required this.message,
    this.phoneError,
    this.nameError,
  });

  @override
  List<Object?> get props => [message, phoneError, nameError];
}

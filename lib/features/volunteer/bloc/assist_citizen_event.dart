import 'package:equatable/equatable.dart';
import 'package:grampulse/features/volunteer/models/citizen_model.dart';

abstract class AssistCitizenEvent extends Equatable {
  const AssistCitizenEvent();

  @override
  List<Object?> get props => [];
}

class InitEvent extends AssistCitizenEvent {}

class PhoneChangedEvent extends AssistCitizenEvent {
  final String phone;

  const PhoneChangedEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class NameChangedEvent extends AssistCitizenEvent {
  final String name;

  const NameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class CitizenSelectedEvent extends AssistCitizenEvent {
  final CitizenModel citizen;

  const CitizenSelectedEvent(this.citizen);

  @override
  List<Object?> get props => [citizen];
}

class ConsentChangedEvent extends AssistCitizenEvent {
  final bool hasConsent;

  const ConsentChangedEvent(this.hasConsent);

  @override
  List<Object?> get props => [hasConsent];
}

class ContinueToReportEvent extends AssistCitizenEvent {}

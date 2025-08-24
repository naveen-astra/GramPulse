import 'package:equatable/equatable.dart';
import 'package:grampulse/features/volunteer/domain/models/citizen_model.dart';

abstract class AssistCitizenEvent extends Equatable {
  const AssistCitizenEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadAssistCitizenScreen extends AssistCitizenEvent {}

class PhoneChangedEvent extends AssistCitizenEvent {
  final String phone;
  
  const PhoneChangedEvent({required this.phone});
  
  @override
  List<Object> get props => [phone];
}

class NameChangedEvent extends AssistCitizenEvent {
  final String name;
  
  const NameChangedEvent({required this.name});
  
  @override
  List<Object> get props => [name];
}

class CitizenSelectedEvent extends AssistCitizenEvent {
  final CitizenModel citizen;
  
  const CitizenSelectedEvent({required this.citizen});
  
  @override
  List<Object> get props => [citizen];
}

class ContinueToReportEvent extends AssistCitizenEvent {
  final String phone;
  final String name;
  
  const ContinueToReportEvent({
    required this.phone,
    required this.name,
  });
  
  @override
  List<Object> get props => [phone, name];
}

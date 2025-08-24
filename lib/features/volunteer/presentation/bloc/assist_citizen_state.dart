import 'package:equatable/equatable.dart';
import 'package:grampulse/features/volunteer/domain/models/citizen_model.dart';

abstract class AssistCitizenState extends Equatable {
  final List<CitizenModel>? recentCitizens;
  final CitizenModel? selectedCitizen;
  
  const AssistCitizenState({
    this.recentCitizens,
    this.selectedCitizen,
  });
  
  @override
  List<Object?> get props => [recentCitizens, selectedCitizen];
}

class AssistInitial extends AssistCitizenState {
  const AssistInitial({List<CitizenModel>? recentCitizens}) 
      : super(recentCitizens: recentCitizens);
}

class AssistLoading extends AssistCitizenState {
  const AssistLoading({
    List<CitizenModel>? recentCitizens,
    CitizenModel? selectedCitizen,
  }) : super(
          recentCitizens: recentCitizens,
          selectedCitizen: selectedCitizen,
        );
}

class AssistValidating extends AssistCitizenState {
  final String phone;
  
  const AssistValidating({
    required this.phone,
    List<CitizenModel>? recentCitizens,
    CitizenModel? selectedCitizen,
  }) : super(
          recentCitizens: recentCitizens,
          selectedCitizen: selectedCitizen,
        );
  
  @override
  List<Object?> get props => [phone, ...super.props];
}

class AssistReady extends AssistCitizenState {
  final CitizenModel citizen;
  
  const AssistReady({
    required this.citizen,
    List<CitizenModel>? recentCitizens,
  }) : super(
          recentCitizens: recentCitizens,
          selectedCitizen: citizen,
        );
  
  @override
  List<Object?> get props => [citizen, ...super.props];
}

class AssistError extends AssistCitizenState {
  final String error;
  
  const AssistError({
    required this.error,
    List<CitizenModel>? recentCitizens,
    CitizenModel? selectedCitizen,
  }) : super(
          recentCitizens: recentCitizens,
          selectedCitizen: selectedCitizen,
        );
  
  @override
  List<Object?> get props => [error, ...super.props];
}

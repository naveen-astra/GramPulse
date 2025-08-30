import 'package:equatable/equatable.dart';
import '../../data/models/department.dart';

abstract class OfficerState extends Equatable {
  const OfficerState();

  @override
  List<Object?> get props => [];
}

// Initial State
class OfficerInitial extends OfficerState {
  const OfficerInitial();
}

// Loading States
class OfficerLoading extends OfficerState {
  const OfficerLoading();
}

class OfficerAuthLoading extends OfficerState {
  const OfficerAuthLoading();
}

// Authentication States
class OfficerOTPRequested extends OfficerState {
  final String phone;

  const OfficerOTPRequested(this.phone);

  @override
  List<Object> get props => [phone];
}

class OfficerAuthenticated extends OfficerState {
  final Map<String, dynamic> userData;
  final Map<String, dynamic>? officerData;

  const OfficerAuthenticated({
    required this.userData,
    this.officerData,
  });

  @override
  List<Object?> get props => [userData, officerData];
}

class OfficerUnauthenticated extends OfficerState {
  const OfficerUnauthenticated();
}

// Dashboard States
class OfficerDashboardLoaded extends OfficerState {
  final Map<String, dynamic> dashboardData;

  const OfficerDashboardLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData];
}

class OfficerIncidentsLoaded extends OfficerState {
  final List<Map<String, dynamic>> incidents;
  final Map<String, dynamic>? pagination;

  const OfficerIncidentsLoaded({
    required this.incidents,
    this.pagination,
  });

  @override
  List<Object?> get props => [incidents, pagination];
}

class OfficerDepartmentsLoaded extends OfficerState {
  final List<Department> departments;

  const OfficerDepartmentsLoaded(this.departments);

  @override
  List<Object> get props => [departments];
}

class OfficerCategoriesLoaded extends OfficerState {
  final List<Map<String, dynamic>> categories;

  const OfficerCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

// Success States
class OfficerAssignmentUpdated extends OfficerState {
  final String message;

  const OfficerAssignmentUpdated(this.message);

  @override
  List<Object> get props => [message];
}

// Error States
class OfficerError extends OfficerState {
  final String message;

  const OfficerError(this.message);

  @override
  List<Object> get props => [message];
}

class OfficerAuthError extends OfficerState {
  final String message;

  const OfficerAuthError(this.message);

  @override
  List<Object> get props => [message];
}

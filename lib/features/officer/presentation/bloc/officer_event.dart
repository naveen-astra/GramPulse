import 'package:equatable/equatable.dart';

abstract class OfficerEvent extends Equatable {
  const OfficerEvent();

  @override
  List<Object?> get props => [];
}

// Authentication Events
class OfficerRequestOTP extends OfficerEvent {
  final String phone;

  const OfficerRequestOTP(this.phone);

  @override
  List<Object> get props => [phone];
}

class OfficerVerifyOTP extends OfficerEvent {
  final String phone;
  final String otp;

  const OfficerVerifyOTP(this.phone, this.otp);

  @override
  List<Object> get props => [phone, otp];
}

class OfficerLoadProfile extends OfficerEvent {
  const OfficerLoadProfile();
}

// Dashboard Events
class OfficerLoadDashboard extends OfficerEvent {
  const OfficerLoadDashboard();
}

class OfficerLoadIncidents extends OfficerEvent {
  final String? category;
  final String? status;
  final int page;

  const OfficerLoadIncidents({
    this.category,
    this.status,
    this.page = 1,
  });

  @override
  List<Object?> get props => [category, status, page];
}

class OfficerUpdateAssignmentStatus extends OfficerEvent {
  final String assignmentId;
  final String status;
  final String? notes;

  const OfficerUpdateAssignmentStatus(
    this.assignmentId,
    this.status, {
    this.notes,
  });

  @override
  List<Object?> get props => [assignmentId, status, notes];
}

class OfficerLoadDepartments extends OfficerEvent {
  const OfficerLoadDepartments();
}

class OfficerLoadCategories extends OfficerEvent {
  const OfficerLoadCategories();
}

class OfficerLogout extends OfficerEvent {
  const OfficerLogout();
}

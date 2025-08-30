// Enhanced Officer Events for Priority Queue and Escalation
import 'package:equatable/equatable.dart';

abstract class EnhancedOfficerEvent extends Equatable {
  const EnhancedOfficerEvent();

  @override
  List<Object?> get props => [];
}

// Priority Queue Events
class LoadPriorityQueue extends EnhancedOfficerEvent {
  final String? department;
  final String? urgencyLevel;
  final int page;
  final int limit;

  const LoadPriorityQueue({
    this.department,
    this.urgencyLevel,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [department, urgencyLevel, page, limit];
}

class LoadEnhancedDashboard extends EnhancedOfficerEvent {
  const LoadEnhancedDashboard();
}

// Escalation Events
class LoadEscalationPaths extends EnhancedOfficerEvent {
  final String incidentId;

  const LoadEscalationPaths(this.incidentId);

  @override
  List<Object> get props => [incidentId];
}

class EscalateIncident extends EnhancedOfficerEvent {
  final String incidentId;
  final String targetOfficerId;
  final String escalationType;
  final String reason;
  final String? attemptedSolutions;
  final String? urgencyJustification;

  const EscalateIncident({
    required this.incidentId,
    required this.targetOfficerId,
    required this.escalationType,
    required this.reason,
    this.attemptedSolutions,
    this.urgencyJustification,
  });

  @override
  List<Object?> get props => [
    incidentId,
    targetOfficerId,
    escalationType,
    reason,
    attemptedSolutions,
    urgencyJustification,
  ];
}

class LoadEscalationHistory extends EnhancedOfficerEvent {
  final String incidentId;

  const LoadEscalationHistory(this.incidentId);

  @override
  List<Object> get props => [incidentId];
}

class LoadPendingEscalations extends EnhancedOfficerEvent {
  final String? department;
  final String? urgency;
  final int page;
  final int limit;

  const LoadPendingEscalations({
    this.department,
    this.urgency,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [department, urgency, page, limit];
}

// Government Structure Events
class LoadGovernmentStructure extends EnhancedOfficerEvent {
  const LoadGovernmentStructure();
}

class LoadJurisdictionIncidents extends EnhancedOfficerEvent {
  final String? jurisdictionLevel;
  final String? department;
  final bool includeCrossDept;
  final int page;
  final int limit;

  const LoadJurisdictionIncidents({
    this.jurisdictionLevel,
    this.department,
    this.includeCrossDept = false,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
    jurisdictionLevel,
    department,
    includeCrossDept,
    page,
    limit,
  ];
}

class CoordinateWithDepartments extends EnhancedOfficerEvent {
  final String incidentId;
  final List<String> targetDepartments;
  final String coordinationType;
  final String message;
  final String urgencyLevel;

  const CoordinateWithDepartments({
    required this.incidentId,
    required this.targetDepartments,
    required this.coordinationType,
    required this.message,
    this.urgencyLevel = 'MEDIUM',
  });

  @override
  List<Object> get props => [
    incidentId,
    targetDepartments,
    coordinationType,
    message,
    urgencyLevel,
  ];
}

class LoadCoordinationStatus extends EnhancedOfficerEvent {
  final String incidentId;

  const LoadCoordinationStatus(this.incidentId);

  @override
  List<Object> get props => [incidentId];
}

// Filter and Refresh Events
class FilterPriorityQueue extends EnhancedOfficerEvent {
  final String? urgencyLevel;
  final String? department;
  final String? slaStatus; // 'BREACHED', 'WARNING', 'NORMAL'

  const FilterPriorityQueue({
    this.urgencyLevel,
    this.department,
    this.slaStatus,
  });

  @override
  List<Object?> get props => [urgencyLevel, department, slaStatus];
}

class RefreshEnhancedData extends EnhancedOfficerEvent {
  const RefreshEnhancedData();
}

class UpdateIncidentPriority extends EnhancedOfficerEvent {
  final String incidentId;
  final int newSeverity;
  final String reason;

  const UpdateIncidentPriority({
    required this.incidentId,
    required this.newSeverity,
    required this.reason,
  });

  @override
  List<Object> get props => [incidentId, newSeverity, reason];
}

// Enhanced Officer States for Priority Queue and Escalation
import 'package:equatable/equatable.dart';

abstract class EnhancedOfficerState extends Equatable {
  const EnhancedOfficerState();

  @override
  List<Object?> get props => [];
}

// Initial States
class EnhancedOfficerInitial extends EnhancedOfficerState {
  const EnhancedOfficerInitial();
}

class EnhancedOfficerLoading extends EnhancedOfficerState {
  const EnhancedOfficerLoading();
}

class EnhancedOfficerError extends EnhancedOfficerState {
  final String message;

  const EnhancedOfficerError(this.message);

  @override
  List<Object> get props => [message];
}

// Dashboard States
class EnhancedDashboardLoaded extends EnhancedOfficerState {
  final Map<String, dynamic> dashboardData;
  final Map<String, dynamic> performanceMetrics;
  final List<Map<String, dynamic>> priorityQueue;

  const EnhancedDashboardLoaded({
    required this.dashboardData,
    required this.performanceMetrics,
    required this.priorityQueue,
  });

  @override
  List<Object> get props => [dashboardData, performanceMetrics, priorityQueue];
}

// Priority Queue States
class PriorityQueueLoaded extends EnhancedOfficerState {
  final List<Map<String, dynamic>> incidents;
  final Map<String, dynamic> statistics;
  final Map<String, dynamic> pagination;
  final Map<String, dynamic> filters;

  const PriorityQueueLoaded({
    required this.incidents,
    required this.statistics,
    required this.pagination,
    required this.filters,
  });

  @override
  List<Object> get props => [incidents, statistics, pagination, filters];

  PriorityQueueLoaded copyWith({
    List<Map<String, dynamic>>? incidents,
    Map<String, dynamic>? statistics,
    Map<String, dynamic>? pagination,
    Map<String, dynamic>? filters,
  }) {
    return PriorityQueueLoaded(
      incidents: incidents ?? this.incidents,
      statistics: statistics ?? this.statistics,
      pagination: pagination ?? this.pagination,
      filters: filters ?? this.filters,
    );
  }
}

// Escalation States
class EscalationPathsLoaded extends EnhancedOfficerState {
  final String incidentId;
  final Map<String, dynamic> currentOfficer;
  final List<Map<String, dynamic>> escalationPaths;
  final List<Map<String, dynamic>> escalationTriggers;
  final Map<String, dynamic> hierarchy;

  const EscalationPathsLoaded({
    required this.incidentId,
    required this.currentOfficer,
    required this.escalationPaths,
    required this.escalationTriggers,
    required this.hierarchy,
  });

  @override
  List<Object> get props => [
    incidentId,
    currentOfficer,
    escalationPaths,
    escalationTriggers,
    hierarchy,
  ];
}

class IncidentEscalated extends EnhancedOfficerState {
  final String message;
  final Map<String, dynamic> escalationData;

  const IncidentEscalated({
    required this.message,
    required this.escalationData,
  });

  @override
  List<Object> get props => [message, escalationData];
}

class EscalationHistoryLoaded extends EnhancedOfficerState {
  final String incidentId;
  final List<Map<String, dynamic>> escalationTrail;
  final List<Map<String, dynamic>> escalationTriggers;
  final int currentLevel;

  const EscalationHistoryLoaded({
    required this.incidentId,
    required this.escalationTrail,
    required this.escalationTriggers,
    required this.currentLevel,
  });

  @override
  List<Object> get props => [
    incidentId,
    escalationTrail,
    escalationTriggers,
    currentLevel,
  ];
}

class PendingEscalationsLoaded extends EnhancedOfficerState {
  final List<Map<String, dynamic>> incidents;
  final Map<String, dynamic> pagination;
  final Map<String, dynamic> officer;

  const PendingEscalationsLoaded({
    required this.incidents,
    required this.pagination,
    required this.officer,
  });

  @override
  List<Object> get props => [incidents, pagination, officer];
}

// Government Structure States
class GovernmentStructureLoaded extends EnhancedOfficerState {
  final Map<String, dynamic> currentOfficer;
  final Map<String, dynamic> hierarchy;
  final Map<String, dynamic> departmentsByLevel;
  final Map<String, dynamic> officerStatsByLevel;
  final List<String> jurisdictionFlow;

  const GovernmentStructureLoaded({
    required this.currentOfficer,
    required this.hierarchy,
    required this.departmentsByLevel,
    required this.officerStatsByLevel,
    required this.jurisdictionFlow,
  });

  @override
  List<Object> get props => [
    currentOfficer,
    hierarchy,
    departmentsByLevel,
    officerStatsByLevel,
    jurisdictionFlow,
  ];
}

class JurisdictionIncidentsLoaded extends EnhancedOfficerState {
  final List<Map<String, dynamic>> incidents;
  final Map<String, dynamic> statistics;
  final Map<String, dynamic> jurisdiction;
  final Map<String, dynamic> pagination;

  const JurisdictionIncidentsLoaded({
    required this.incidents,
    required this.statistics,
    required this.jurisdiction,
    required this.pagination,
  });

  @override
  List<Object> get props => [incidents, statistics, jurisdiction, pagination];
}

class DepartmentCoordinated extends EnhancedOfficerState {
  final String message;
  final Map<String, dynamic> coordinationData;

  const DepartmentCoordinated({
    required this.message,
    required this.coordinationData,
  });

  @override
  List<Object> get props => [message, coordinationData];
}

class CoordinationStatusLoaded extends EnhancedOfficerState {
  final Map<String, dynamic> incident;
  final List<Map<String, dynamic>> coordinationStatus;
  final Map<String, dynamic> metrics;
  final List<Map<String, dynamic>> coordinatingDepartments;

  const CoordinationStatusLoaded({
    required this.incident,
    required this.coordinationStatus,
    required this.metrics,
    required this.coordinatingDepartments,
  });

  @override
  List<Object> get props => [
    incident,
    coordinationStatus,
    metrics,
    coordinatingDepartments,
  ];
}

// Success States
class IncidentPriorityUpdated extends EnhancedOfficerState {
  final String message;
  final String incidentId;
  final int newPriorityScore;

  const IncidentPriorityUpdated({
    required this.message,
    required this.incidentId,
    required this.newPriorityScore,
  });

  @override
  List<Object> get props => [message, incidentId, newPriorityScore];
}

// Combined State for Complex Operations
class EnhancedOfficerDataLoaded extends EnhancedOfficerState {
  final Map<String, dynamic> dashboardData;
  final List<Map<String, dynamic>> priorityQueue;
  final Map<String, dynamic> governmentStructure;
  final Map<String, dynamic> performanceMetrics;

  const EnhancedOfficerDataLoaded({
    required this.dashboardData,
    required this.priorityQueue,
    required this.governmentStructure,
    required this.performanceMetrics,
  });

  @override
  List<Object> get props => [
    dashboardData,
    priorityQueue,
    governmentStructure,
    performanceMetrics,
  ];

  EnhancedOfficerDataLoaded copyWith({
    Map<String, dynamic>? dashboardData,
    List<Map<String, dynamic>>? priorityQueue,
    Map<String, dynamic>? governmentStructure,
    Map<String, dynamic>? performanceMetrics,
  }) {
    return EnhancedOfficerDataLoaded(
      dashboardData: dashboardData ?? this.dashboardData,
      priorityQueue: priorityQueue ?? this.priorityQueue,
      governmentStructure: governmentStructure ?? this.governmentStructure,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
    );
  }
}

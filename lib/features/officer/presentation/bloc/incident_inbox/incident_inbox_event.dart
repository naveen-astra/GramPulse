import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';

abstract class IncidentInboxEvent extends Equatable {
  const IncidentInboxEvent();

  @override
  List<Object?> get props => [];
}

class LoadIncidentsEvent extends IncidentInboxEvent {
  const LoadIncidentsEvent();
}

class FilterIncidentsEvent extends IncidentInboxEvent {
  final Map<String, dynamic> filters;

  const FilterIncidentsEvent(this.filters);

  @override
  List<Object> get props => [filters];
}

class SortIncidentsEvent extends IncidentInboxEvent {
  final String column;
  final bool ascending;

  const SortIncidentsEvent(this.column, this.ascending);

  @override
  List<Object> get props => [column, ascending];
}

class UpdateIncidentStatusEvent extends IncidentInboxEvent {
  final String incidentId;
  final OfficerIssueStatus newStatus;

  const UpdateIncidentStatusEvent(this.incidentId, this.newStatus);

  @override
  List<Object> get props => [incidentId, newStatus];
}

class AssignSelectedIncidentsEvent extends IncidentInboxEvent {
  final List<String> incidentIds;

  const AssignSelectedIncidentsEvent(this.incidentIds);

  @override
  List<Object> get props => [incidentIds];
}

class UpdateSelectedIncidentsStatusEvent extends IncidentInboxEvent {
  final List<String> incidentIds;
  final OfficerIssueStatus newStatus;

  const UpdateSelectedIncidentsStatusEvent(this.incidentIds, this.newStatus);

  @override
  List<Object> get props => [incidentIds, newStatus];
}

class ExportSelectedIncidentsEvent extends IncidentInboxEvent {
  final List<String> incidentIds;

  const ExportSelectedIncidentsEvent(this.incidentIds);

  @override
  List<Object> get props => [incidentIds];
}

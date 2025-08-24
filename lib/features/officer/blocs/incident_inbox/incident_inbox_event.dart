import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart';

abstract class IncidentInboxEvent extends Equatable {
  const IncidentInboxEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadInboxEvent extends IncidentInboxEvent {}

class ApplyFiltersEvent extends IncidentInboxEvent {
  final Map<String, dynamic> filters;
  
  const ApplyFiltersEvent(this.filters);
  
  @override
  List<Object?> get props => [filters];
}

class ResetFiltersEvent extends IncidentInboxEvent {}

class ToggleViewTypeEvent extends IncidentInboxEvent {
  final String viewType;
  
  const ToggleViewTypeEvent(this.viewType);
  
  @override
  List<Object> get props => [viewType];
}

class SortIssuesEvent extends IncidentInboxEvent {
  final String field;
  final bool ascending;
  
  const SortIssuesEvent(this.field, this.ascending);
  
  @override
  List<Object> get props => [field, ascending];
}

class SelectIssueEvent extends IncidentInboxEvent {
  final String id;
  final bool selected;
  
  const SelectIssueEvent(this.id, this.selected);
  
  @override
  List<Object> get props => [id, selected];
}

class ClearSelectionEvent extends IncidentInboxEvent {}

class QuickActionEvent extends IncidentInboxEvent {
  final OfficerIssueModel issue;
  final String action;
  
  const QuickActionEvent(this.issue, this.action);
  
  @override
  List<Object> get props => [issue, action];
}

class BatchActionEvent extends IncidentInboxEvent {
  final List<String> ids;
  final String action;
  
  const BatchActionEvent(this.ids, this.action);
  
  @override
  List<Object> get props => [ids, action];
}

class UpdateStatusEvent extends IncidentInboxEvent {
  final OfficerIssueModel issue;
  final String newStatus;
  
  const UpdateStatusEvent(this.issue, this.newStatus);
  
  @override
  List<Object> get props => [issue, newStatus];
}

class ToggleFilterPanelEvent extends IncidentInboxEvent {
  final bool isOpen;
  
  const ToggleFilterPanelEvent(this.isOpen);
  
  @override
  List<Object> get props => [isOpen];
}

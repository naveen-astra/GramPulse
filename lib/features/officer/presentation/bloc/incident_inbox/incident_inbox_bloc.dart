import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_inbox/incident_inbox_state.dart';

class IncidentInboxBloc extends Bloc<IncidentInboxEvent, IncidentInboxState> {
  final OfficerRepository _repository;

  IncidentInboxBloc({required OfficerRepository repository}) 
      : _repository = repository,
        super(const IncidentInboxInitial()) {
    on<LoadIncidentsEvent>(_onLoadIncidents);
    on<FilterIncidentsEvent>(_onFilterIncidents);
    on<SortIncidentsEvent>(_onSortIncidents);
    on<UpdateIncidentStatusEvent>(_onUpdateIncidentStatus);
    on<AssignSelectedIncidentsEvent>(_onAssignSelectedIncidents);
    on<UpdateSelectedIncidentsStatusEvent>(_onUpdateSelectedIncidentsStatus);
    on<ExportSelectedIncidentsEvent>(_onExportSelectedIncidents);
  }

  Future<void> _onLoadIncidents(
    LoadIncidentsEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    emit(const IncidentInboxLoading());

    try {
      final issues = await _repository.getOfficerIssues();
      emit(IncidentInboxLoaded(issues: issues));
    } catch (e) {
      emit(IncidentInboxError('Failed to load incidents: ${e.toString()}'));
    }
  }

  Future<void> _onFilterIncidents(
    FilterIncidentsEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    if (state is! IncidentInboxLoaded) return;
    
    final currentState = state as IncidentInboxLoaded;
    
    emit(const IncidentInboxLoading());

    try {
      final filteredIssues = await _repository.filterOfficerIssues(
        currentState.issues,
        event.filters,
      );
      
      emit(currentState.copyWith(
        issues: filteredIssues,
        filters: event.filters,
      ));
    } catch (e) {
      emit(IncidentInboxError('Failed to filter incidents: ${e.toString()}'));
    }
  }

  void _onSortIncidents(
    SortIncidentsEvent event,
    Emitter<IncidentInboxState> emit,
  ) {
    if (state is! IncidentInboxLoaded) return;
    
    final currentState = state as IncidentInboxLoaded;
    final issues = List<OfficerIssueModel>.from(currentState.issues);

    // Sort the issues based on the column
    issues.sort((a, b) {
      int result;
      
      switch (event.column) {
        case 'id':
          result = a.id.compareTo(b.id);
          break;
        case 'title':
          result = a.title.compareTo(b.title);
          break;
        case 'category':
          result = a.category.compareTo(b.category);
          break;
        case 'status':
          result = a.status.index.compareTo(b.status.index);
          break;
        case 'priority':
          result = a.priority.index.compareTo(b.priority.index);
          break;
        case 'dateReported':
          result = a.dateReported.compareTo(b.dateReported);
          break;
        case 'slaRemaining':
          result = a.slaRemaining.compareTo(b.slaRemaining);
          break;
        default:
          result = 0;
      }

      return event.ascending ? result : -result;
    });

    emit(currentState.copyWith(
      issues: issues,
      sortColumn: event.column,
      isAscending: event.ascending,
    ));
  }

  Future<void> _onUpdateIncidentStatus(
    UpdateIncidentStatusEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    if (state is! IncidentInboxLoaded) return;
    
    final currentState = state as IncidentInboxLoaded;
    
    try {
      await _repository.updateIssueStatus(
        event.incidentId, 
        event.newStatus,
      );
      
      final updatedIssues = currentState.issues.map((issue) {
        if (issue.id == event.incidentId) {
          return issue.copyWith(status: event.newStatus);
        }
        return issue;
      }).toList();
      
      emit(currentState.copyWith(issues: updatedIssues));
    } catch (e) {
      emit(IncidentInboxError('Failed to update incident status: ${e.toString()}'));
    }
  }

  Future<void> _onAssignSelectedIncidents(
    AssignSelectedIncidentsEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    if (state is! IncidentInboxLoaded) return;
    
    final currentState = state as IncidentInboxLoaded;
    
    try {
      // This would typically show an assignment dialog and then call the repository
      // For now, we'll just simulate the assignment to "Current Officer"
      
      final updatedIssues = currentState.issues.map((issue) {
        if (event.incidentIds.contains(issue.id)) {
          return issue.copyWith(assignedTo: "Current Officer");
        }
        return issue;
      }).toList();
      
      emit(currentState.copyWith(issues: updatedIssues));
    } catch (e) {
      emit(IncidentInboxError('Failed to assign incidents: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSelectedIncidentsStatus(
    UpdateSelectedIncidentsStatusEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    if (state is! IncidentInboxLoaded) return;
    
    final currentState = state as IncidentInboxLoaded;
    
    try {
      // Update status for all selected incidents
      final updatedIssues = currentState.issues.map((issue) {
        if (event.incidentIds.contains(issue.id)) {
          return issue.copyWith(status: event.newStatus);
        }
        return issue;
      }).toList();
      
      emit(currentState.copyWith(issues: updatedIssues));
    } catch (e) {
      emit(IncidentInboxError('Failed to update incidents status: ${e.toString()}'));
    }
  }

  Future<void> _onExportSelectedIncidents(
    ExportSelectedIncidentsEvent event,
    Emitter<IncidentInboxState> emit,
  ) async {
    if (state is! IncidentInboxLoaded) return;
    
    try {
      // In a real implementation, this would generate a report or file
      // For now we'll just simulate successful export
      
      // The state doesn't change for export operation
    } catch (e) {
      emit(IncidentInboxError('Failed to export incidents: ${e.toString()}'));
    }
  }
}

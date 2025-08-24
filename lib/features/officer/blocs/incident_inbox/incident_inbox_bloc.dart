import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/map/domain/models/category_model.dart';
import 'package:grampulse/features/officer/blocs/incident_inbox/incident_inbox_event.dart';
import 'package:grampulse/features/officer/blocs/incident_inbox/incident_inbox_state.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart';
import 'package:flutter/material.dart';

class IncidentInboxBloc extends Bloc<IncidentInboxEvent, IncidentInboxState> {
  IncidentInboxBloc() : super(InboxInitial()) {
    on<LoadInboxEvent>(_onLoadInbox);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ResetFiltersEvent>(_onResetFilters);
    on<ToggleViewTypeEvent>(_onToggleViewType);
    on<SortIssuesEvent>(_onSortIssues);
    on<SelectIssueEvent>(_onSelectIssue);
    on<ClearSelectionEvent>(_onClearSelection);
    on<QuickActionEvent>(_onQuickAction);
    on<BatchActionEvent>(_onBatchAction);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<ToggleFilterPanelEvent>(_onToggleFilterPanel);
  }
  
  Future<void> _onLoadInbox(LoadInboxEvent event, Emitter<IncidentInboxState> emit) async {
    emit(InboxLoading());
    
    try {
      // In a real app, this would fetch data from an API
      await Future.delayed(const Duration(seconds: 1));
      
      final categories = _getMockCategories();
      final issues = _getMockIssues(categories);
      
      emit(InboxLoaded(
        issues: issues,
        categories: categories,
        filters: {},
        sortField: 'createdAt',
        sortAscending: false, // Newest first by default
        selectedIds: {},
        viewType: 'list',
        isFilterPanelOpen: false,
      ));
    } catch (e) {
      emit(InboxError(e.toString()));
    }
  }
  
  void _onApplyFilters(ApplyFiltersEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      emit(InboxFiltering(currentState));
      
      // In a real app, this would call an API with filters
      final filteredIssues = _applyFilters(_getMockIssues(currentState.categories), event.filters);
      
      emit(currentState.copyWith(
        issues: filteredIssues,
        filters: event.filters,
        selectedIds: {},
      ));
    }
  }
  
  void _onResetFilters(ResetFiltersEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      emit(InboxFiltering(currentState));
      
      final allIssues = _getMockIssues(currentState.categories);
      
      emit(currentState.copyWith(
        issues: allIssues,
        filters: {},
        selectedIds: {},
      ));
    }
  }
  
  void _onToggleViewType(ToggleViewTypeEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      emit(currentState.copyWith(
        viewType: event.viewType,
        selectedIds: {}, // Clear selection when changing view
      ));
    }
  }
  
  void _onSortIssues(SortIssuesEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      final sortedIssues = List<OfficerIssueModel>.from(currentState.issues);
      
      sortedIssues.sort((a, b) {
        dynamic valueA;
        dynamic valueB;
        
        switch (event.field) {
          case 'id':
            valueA = a.id;
            valueB = b.id;
            break;
          case 'category':
            valueA = a.category.name;
            valueB = b.category.name;
            break;
          case 'title':
            valueA = a.title;
            valueB = b.title;
            break;
          case 'status':
            valueA = a.status;
            valueB = b.status;
            break;
          case 'priority':
            valueA = a.priority;
            valueB = b.priority;
            break;
          case 'sla':
            valueA = a.slaPercentage;
            valueB = b.slaPercentage;
            break;
          case 'createdAt':
          default:
            valueA = a.createdAt;
            valueB = b.createdAt;
            break;
        }
        
        int comparison = valueA.compareTo(valueB);
        return event.ascending ? comparison : -comparison;
      });
      
      emit(currentState.copyWith(
        issues: sortedIssues,
        sortField: event.field,
        sortAscending: event.ascending,
      ));
    }
  }
  
  void _onSelectIssue(SelectIssueEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      final newSelectedIds = Set<String>.from(currentState.selectedIds);
      
      if (event.selected) {
        newSelectedIds.add(event.id);
      } else {
        newSelectedIds.remove(event.id);
      }
      
      emit(currentState.copyWith(
        selectedIds: newSelectedIds,
      ));
    }
  }
  
  void _onClearSelection(ClearSelectionEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      emit(currentState.copyWith(
        selectedIds: {},
      ));
    }
  }
  
  void _onQuickAction(QuickActionEvent event, Emitter<IncidentInboxState> emit) async {
    final currentState = state;
    if (currentState is InboxLoaded) {
      // Show loading state
      emit(InboxLoading());
      
      try {
        // In a real app, this would call an API
        await Future.delayed(const Duration(seconds: 1));
        
        // Update issue status based on action
        final newStatus = _getNewStatusForAction(event.issue.status, event.action);
        final updatedIssue = event.issue.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
        
        final updatedIssues = currentState.issues.map((issue) {
          return issue.id == updatedIssue.id ? updatedIssue : issue;
        }).toList();
        
        emit(currentState.copyWith(
          issues: updatedIssues,
        ));
      } catch (e) {
        emit(InboxError(e.toString()));
        emit(currentState); // Restore previous state
      }
    }
  }
  
  void _onBatchAction(BatchActionEvent event, Emitter<IncidentInboxState> emit) async {
    final currentState = state;
    if (currentState is InboxLoaded) {
      // Show loading state
      emit(InboxLoading());
      
      try {
        // In a real app, this would call an API
        await Future.delayed(const Duration(seconds: 1));
        
        // Handle different batch actions
        switch (event.action) {
          case 'assign':
          case 'update_status':
          case 'export':
            // These would call different API endpoints
            break;
        }
        
        // For now, just restore the state without changes
        emit(currentState.copyWith(
          selectedIds: {}, // Clear selection after batch action
        ));
      } catch (e) {
        emit(InboxError(e.toString()));
        emit(currentState); // Restore previous state
      }
    }
  }
  
  void _onUpdateStatus(UpdateStatusEvent event, Emitter<IncidentInboxState> emit) async {
    final currentState = state;
    if (currentState is InboxLoaded) {
      // Show loading state
      emit(InboxLoading());
      
      try {
        // In a real app, this would call an API
        await Future.delayed(const Duration(seconds: 1));
        
        final updatedIssue = event.issue.copyWith(
          status: event.newStatus,
          updatedAt: DateTime.now(),
        );
        
        final updatedIssues = currentState.issues.map((issue) {
          return issue.id == updatedIssue.id ? updatedIssue : issue;
        }).toList();
        
        emit(currentState.copyWith(
          issues: updatedIssues,
        ));
      } catch (e) {
        emit(InboxError(e.toString()));
        emit(currentState); // Restore previous state
      }
    }
  }
  
  void _onToggleFilterPanel(ToggleFilterPanelEvent event, Emitter<IncidentInboxState> emit) {
    final currentState = state;
    if (currentState is InboxLoaded) {
      emit(currentState.copyWith(
        isFilterPanelOpen: event.isOpen,
      ));
    }
  }
  
  // Helper methods for mock data
  
  List<CategoryModel> _getMockCategories() {
    return [
      CategoryModel(
        id: 'roads',
        name: 'Roads',
        iconCode: '0xe567', // local_road
        color: Colors.brown,
      ),
      CategoryModel(
        id: 'water',
        name: 'Water',
        iconCode: '0xe798', // water_drop
        color: Colors.blue,
      ),
      CategoryModel(
        id: 'power',
        name: 'Electricity',
        iconCode: '0xe63c', // power
        color: Colors.amber,
      ),
      CategoryModel(
        id: 'sanitation',
        name: 'Sanitation',
        iconCode: '0xf1ad', // cleaning_services
        color: Colors.green,
      ),
      CategoryModel(
        id: 'safety',
        name: 'Safety',
        iconCode: '0xe32a', // health_and_safety
        color: Colors.red,
      ),
      CategoryModel(
        id: 'others',
        name: 'Others',
        iconCode: '0xe3c9', // more
        color: Colors.purple,
      ),
    ];
  }
  
  List<OfficerIssueModel> _getMockIssues(List<CategoryModel> categories) {
    final now = DateTime.now();
    
    return [
      OfficerIssueModel(
        id: '1234abcd',
        title: 'Pothole on Main Street',
        description: 'Large pothole causing traffic issues',
        category: categories.firstWhere((c) => c.id == 'roads'),
        status: 'new',
        priority: 'high',
        createdAt: now.subtract(const Duration(days: 2)),
        slaPercentage: 80, // 80% of SLA time used
        slaDueAt: now.add(const Duration(hours: 12)),
        location: 'Main Street, Near City Hall',
      ),
      OfficerIssueModel(
        id: '5678efgh',
        title: 'Water leakage near Park',
        description: 'Continuous water leakage for past 3 days',
        category: categories.firstWhere((c) => c.id == 'water'),
        status: 'assigned',
        priority: 'medium',
        createdAt: now.subtract(const Duration(days: 3)),
        assignedAt: now.subtract(const Duration(days: 2)),
        assignedTo: 'Officer Kumar',
        slaPercentage: 90, // 90% of SLA time used
        slaDueAt: now.add(const Duration(hours: 6)),
        location: 'Central Park, East Entrance',
      ),
      OfficerIssueModel(
        id: '9012ijkl',
        title: 'Streetlight not working',
        description: 'Street light has been out for a week causing safety concerns',
        category: categories.firstWhere((c) => c.id == 'power'),
        status: 'in_progress',
        priority: 'medium',
        createdAt: now.subtract(const Duration(days: 5)),
        assignedAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 1)),
        assignedTo: 'Officer Singh',
        slaPercentage: 110, // SLA breached
        slaDueAt: now.subtract(const Duration(hours: 24)),
        location: 'Gandhi Road, Near Bus Stop',
      ),
      OfficerIssueModel(
        id: '3456mnop',
        title: 'Garbage not collected',
        description: 'Garbage has not been collected for over a week',
        category: categories.firstWhere((c) => c.id == 'sanitation'),
        status: 'resolved',
        priority: 'low',
        createdAt: now.subtract(const Duration(days: 7)),
        assignedAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(hours: 12)),
        assignedTo: 'Officer Sharma',
        slaPercentage: 95,
        slaDueAt: now.subtract(const Duration(hours: 6)),
        location: 'Residential Colony, Block B',
      ),
      OfficerIssueModel(
        id: '7890qrst',
        title: 'Unsafe construction site',
        description: 'Construction site lacks proper safety barriers',
        category: categories.firstWhere((c) => c.id == 'safety'),
        status: 'closed',
        priority: 'high',
        createdAt: now.subtract(const Duration(days: 10)),
        assignedAt: now.subtract(const Duration(days: 9)),
        updatedAt: now.subtract(const Duration(days: 1)),
        assignedTo: 'Officer Patel',
        slaPercentage: 70,
        slaDueAt: now.add(const Duration(days: 1)),
        location: 'New Development Area, Plot 12',
      ),
      OfficerIssueModel(
        id: '1234uvwx',
        title: 'Public bench damaged',
        description: 'Wooden bench in park is broken and has sharp edges',
        category: categories.firstWhere((c) => c.id == 'others'),
        status: 'rejected',
        priority: 'low',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 14)),
        slaPercentage: 100,
        slaDueAt: now.subtract(const Duration(hours: 1)),
        location: 'City Park, Near Fountain',
      ),
      OfficerIssueModel(
        id: '5678yzab',
        title: 'Road sign missing',
        description: 'Stop sign at intersection has been removed',
        category: categories.firstWhere((c) => c.id == 'roads'),
        status: 'new',
        priority: 'medium',
        createdAt: now.subtract(const Duration(hours: 12)),
        slaPercentage: 15,
        slaDueAt: now.add(const Duration(days: 3)),
        location: 'Junction of Main St and Park Ave',
      ),
    ];
  }
  
  List<OfficerIssueModel> _applyFilters(
    List<OfficerIssueModel> issues,
    Map<String, dynamic> filters,
  ) {
    return issues.where((issue) {
      // Filter by status
      if (filters['status'] != null && issue.status != filters['status']) {
        return false;
      }
      
      // Filter by category
      if (filters['categoryId'] != null && issue.category.id != filters['categoryId']) {
        return false;
      }
      
      // Filter by SLA status
      if (filters['slaStatus'] != null) {
        switch (filters['slaStatus']) {
          case 'breached':
            if (issue.slaPercentage < 100) return false;
            break;
          case 'at_risk':
            if (issue.slaPercentage < 75 || issue.slaPercentage >= 100) return false;
            break;
          case 'on_track':
            if (issue.slaPercentage >= 75) return false;
            break;
        }
      }
      
      // Filter by date range
      if (filters['startDate'] != null) {
        final startDate = DateTime.parse(filters['startDate']);
        if (issue.createdAt.isBefore(startDate)) return false;
      }
      
      if (filters['endDate'] != null) {
        final endDate = DateTime.parse(filters['endDate']).add(const Duration(days: 1)); // Include the whole day
        if (issue.createdAt.isAfter(endDate)) return false;
      }
      
      return true;
    }).toList();
  }
  
  String _getNewStatusForAction(String currentStatus, String action) {
    switch (action) {
      case 'assign':
        return 'assigned';
      case 'resolve':
        return 'resolved';
      case 'close':
        return 'closed';
      default:
        return currentStatus;
    }
  }
}

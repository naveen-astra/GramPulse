import 'package:equatable/equatable.dart';
import 'package:grampulse/features/map/domain/models/category_model.dart';
import 'package:grampulse/features/officer/models/officer_issue_model.dart';

abstract class IncidentInboxState extends Equatable {
  const IncidentInboxState();
  
  @override
  List<Object?> get props => [];
}

class InboxInitial extends IncidentInboxState {}

class InboxLoading extends IncidentInboxState {}

class InboxLoaded extends IncidentInboxState {
  final List<OfficerIssueModel> issues;
  final List<CategoryModel> categories;
  final Map<String, dynamic> filters;
  final String sortField;
  final bool sortAscending;
  final Set<String> selectedIds;
  final String viewType; // 'list' or 'kanban'
  final bool isFilterPanelOpen;

  const InboxLoaded({
    required this.issues,
    required this.categories,
    required this.filters,
    required this.sortField,
    required this.sortAscending,
    required this.selectedIds,
    required this.viewType,
    required this.isFilterPanelOpen,
  });
  
  @override
  List<Object?> get props => [
    issues,
    categories,
    filters,
    sortField,
    sortAscending,
    selectedIds,
    viewType,
    isFilterPanelOpen,
  ];
  
  InboxLoaded copyWith({
    List<OfficerIssueModel>? issues,
    List<CategoryModel>? categories,
    Map<String, dynamic>? filters,
    String? sortField,
    bool? sortAscending,
    Set<String>? selectedIds,
    String? viewType,
    bool? isFilterPanelOpen,
  }) {
    return InboxLoaded(
      issues: issues ?? this.issues,
      categories: categories ?? this.categories,
      filters: filters ?? this.filters,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedIds: selectedIds ?? this.selectedIds,
      viewType: viewType ?? this.viewType,
      isFilterPanelOpen: isFilterPanelOpen ?? this.isFilterPanelOpen,
    );
  }
}

class InboxFiltering extends IncidentInboxState {
  final InboxLoaded previousState;
  
  const InboxFiltering(this.previousState);
  
  @override
  List<Object?> get props => [previousState];
}

class InboxError extends IncidentInboxState {
  final String message;
  
  const InboxError(this.message);
  
  @override
  List<Object> get props => [message];
}

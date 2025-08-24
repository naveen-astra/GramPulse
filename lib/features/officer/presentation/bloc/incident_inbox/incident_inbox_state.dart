import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';

abstract class IncidentInboxState extends Equatable {
  const IncidentInboxState();

  @override
  List<Object?> get props => [];
}

class IncidentInboxInitial extends IncidentInboxState {
  const IncidentInboxInitial();
}

class IncidentInboxLoading extends IncidentInboxState {
  const IncidentInboxLoading();
}

class IncidentInboxLoaded extends IncidentInboxState {
  final List<OfficerIssueModel> issues;
  final String? sortColumn;
  final bool isAscending;
  final Map<String, dynamic>? filters;

  const IncidentInboxLoaded({
    required this.issues,
    this.sortColumn,
    this.isAscending = true,
    this.filters,
  });

  @override
  List<Object?> get props => [issues, sortColumn, isAscending, filters];

  IncidentInboxLoaded copyWith({
    List<OfficerIssueModel>? issues,
    String? sortColumn,
    bool? isAscending,
    Map<String, dynamic>? filters,
    ValueGetter<Map<String, dynamic>?>? filtersGetter,
  }) {
    return IncidentInboxLoaded(
      issues: issues ?? this.issues,
      sortColumn: sortColumn ?? this.sortColumn,
      isAscending: isAscending ?? this.isAscending,
      filters: filtersGetter != null ? filtersGetter() : (filters ?? this.filters),
    );
  }
}

class IncidentInboxError extends IncidentInboxState {
  final String message;

  const IncidentInboxError(this.message);

  @override
  List<Object> get props => [message];
}

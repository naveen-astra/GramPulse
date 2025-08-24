import 'package:flutter/material.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';

enum OfficerIssueStatus {
  open,
  inProgress,
  assigned,
  resolved,
  closed,
  reopened;

  String localizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case OfficerIssueStatus.open:
        return l10n.issueStatusOpen;
      case OfficerIssueStatus.inProgress:
        return l10n.issueStatusInProgress;
      case OfficerIssueStatus.assigned:
        return l10n.issueStatusAssigned;
      case OfficerIssueStatus.resolved:
        return l10n.issueStatusResolved;
      case OfficerIssueStatus.closed:
        return l10n.issueStatusClosed;
      case OfficerIssueStatus.reopened:
        return l10n.issueStatusReopened;
    }
  }

  Color getColor() {
    switch (this) {
      case OfficerIssueStatus.open:
        return Colors.red;
      case OfficerIssueStatus.inProgress:
        return Colors.orange;
      case OfficerIssueStatus.assigned:
        return Colors.blue;
      case OfficerIssueStatus.resolved:
        return Colors.green;
      case OfficerIssueStatus.closed:
        return Colors.grey;
      case OfficerIssueStatus.reopened:
        return Colors.purple;
    }
  }
}

enum IssuePriority {
  low,
  medium,
  high,
  critical;

  String localizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case IssuePriority.low:
        return l10n.priorityLow;
      case IssuePriority.medium:
        return l10n.priorityMedium;
      case IssuePriority.high:
        return l10n.priorityHigh;
      case IssuePriority.critical:
        return l10n.priorityCritical;
    }
  }

  Color getColor() {
    switch (this) {
      case IssuePriority.low:
        return Colors.green;
      case IssuePriority.medium:
        return Colors.blue;
      case IssuePriority.high:
        return Colors.orange;
      case IssuePriority.critical:
        return Colors.red;
    }
  }
}

class OfficerIssueModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final OfficerIssueStatus status;
  final IssuePriority priority;
  final DateTime dateReported;
  final DateTime? lastUpdated;
  final String reportedBy;
  final String? assignedTo;
  final Duration slaRemaining;
  final List<String>? attachments;
  final Map<String, dynamic>? metadata;

  OfficerIssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.priority,
    required this.dateReported,
    this.lastUpdated,
    required this.reportedBy,
    this.assignedTo,
    required this.slaRemaining,
    this.attachments,
    this.metadata,
  });

  OfficerIssueModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    OfficerIssueStatus? status,
    IssuePriority? priority,
    DateTime? dateReported,
    DateTime? lastUpdated,
    String? reportedBy,
    String? assignedTo,
    Duration? slaRemaining,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return OfficerIssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dateReported: dateReported ?? this.dateReported,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      reportedBy: reportedBy ?? this.reportedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      slaRemaining: slaRemaining ?? this.slaRemaining,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }
}

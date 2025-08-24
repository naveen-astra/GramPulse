import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

abstract class IncidentDetailsState extends Equatable {
  const IncidentDetailsState();

  @override
  List<Object?> get props => [];
}

class IncidentDetailsInitial extends IncidentDetailsState {}

class IncidentDetailsLoading extends IncidentDetailsState {}

class IncidentDetailsLoaded extends IncidentDetailsState {
  final IssueModel issue;
  final List<WorkOrderModel> workOrders;
  final List<TimelineEntryModel> timeline;

  const IncidentDetailsLoaded({
    required this.issue,
    this.workOrders = const [],
    this.timeline = const [],
  });

  IncidentDetailsLoaded copyWith({
    IssueModel? issue,
    List<WorkOrderModel>? workOrders,
    List<TimelineEntryModel>? timeline,
  }) {
    return IncidentDetailsLoaded(
      issue: issue ?? this.issue,
      workOrders: workOrders ?? this.workOrders,
      timeline: timeline ?? this.timeline,
    );
  }

  @override
  List<Object> get props => [issue, workOrders, timeline];
}

class IncidentDetailsError extends IncidentDetailsState {
  final String message;

  const IncidentDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class WorkOrderUpdating extends IncidentDetailsState {
  final IssueModel issue;
  final List<WorkOrderModel> workOrders;
  final List<TimelineEntryModel> timeline;

  const WorkOrderUpdating({
    required this.issue,
    required this.workOrders,
    required this.timeline,
  });

  @override
  List<Object> get props => [issue, workOrders, timeline];
}

class StatusUpdating extends IncidentDetailsState {
  final IssueModel issue;
  final List<WorkOrderModel> workOrders;
  final List<TimelineEntryModel> timeline;
  final OfficerIssueStatus newStatus;

  const StatusUpdating({
    required this.issue,
    required this.workOrders,
    required this.timeline,
    required this.newStatus,
  });

  @override
  List<Object> get props => [issue, workOrders, timeline, newStatus];
}

class CommentAdding extends IncidentDetailsState {
  final IssueModel issue;
  final List<WorkOrderModel> workOrders;
  final List<TimelineEntryModel> timeline;

  const CommentAdding({
    required this.issue,
    required this.workOrders,
    required this.timeline,
  });

  @override
  List<Object> get props => [issue, workOrders, timeline];
}

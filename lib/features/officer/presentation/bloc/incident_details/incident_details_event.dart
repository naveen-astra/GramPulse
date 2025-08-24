import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/domain/models/officer_issue_model.dart';

abstract class IncidentDetailsEvent extends Equatable {
  const IncidentDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadIncidentDetailsEvent extends IncidentDetailsEvent {
  final String incidentId;

  const LoadIncidentDetailsEvent(this.incidentId);

  @override
  List<Object> get props => [incidentId];
}

class UpdateIncidentStatusEvent extends IncidentDetailsEvent {
  final OfficerIssueStatus status;

  const UpdateIncidentStatusEvent(this.status);

  @override
  List<Object> get props => [status];
}

class CreateWorkOrderEvent extends IncidentDetailsEvent {
  final String title;
  final String description;
  final String assignedTo;
  final DateTime dueDate;
  final double? estimatedCost;

  const CreateWorkOrderEvent({
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dueDate,
    this.estimatedCost,
  });

  @override
  List<Object?> get props => [title, description, assignedTo, dueDate, estimatedCost];
}

class DeleteWorkOrderEvent extends IncidentDetailsEvent {
  final String workOrderId;

  const DeleteWorkOrderEvent(this.workOrderId);

  @override
  List<Object> get props => [workOrderId];
}

class AddCommentEvent extends IncidentDetailsEvent {
  final String comment;

  const AddCommentEvent(this.comment);

  @override
  List<Object> get props => [comment];
}

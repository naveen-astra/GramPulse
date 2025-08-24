import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/incident_details/incident_details_state.dart';

class IncidentDetailsBloc extends Bloc<IncidentDetailsEvent, IncidentDetailsState> {
  final OfficerRepository _repository;

  IncidentDetailsBloc({
    required OfficerRepository repository,
  })  : _repository = repository,
        super(IncidentDetailsInitial()) {
    on<LoadIncidentDetailsEvent>(_onLoadIncidentDetails);
    on<UpdateIncidentStatusEvent>(_onUpdateIncidentStatus);
    on<CreateWorkOrderEvent>(_onCreateWorkOrder);
    on<DeleteWorkOrderEvent>(_onDeleteWorkOrder);
    on<AddCommentEvent>(_onAddComment);
  }

  Future<void> _onLoadIncidentDetails(
    LoadIncidentDetailsEvent event,
    Emitter<IncidentDetailsState> emit,
  ) async {
    emit(IncidentDetailsLoading());
    
    try {
      final issue = await _repository.getIssueById(event.incidentId);
      final workOrders = await _repository.getWorkOrdersForIssue(event.incidentId);
      final timeline = await _repository.getTimelineForIssue(event.incidentId);
      
      emit(IncidentDetailsLoaded(
        issue: issue,
        workOrders: workOrders,
        timeline: timeline,
      ));
    } catch (e) {
      emit(IncidentDetailsError(e.toString()));
    }
  }

  Future<void> _onUpdateIncidentStatus(
    UpdateIncidentStatusEvent event,
    Emitter<IncidentDetailsState> emit,
  ) async {
    if (state is IncidentDetailsLoaded) {
      final currentState = state as IncidentDetailsLoaded;
      
      emit(StatusUpdating(
        issue: currentState.issue,
        workOrders: currentState.workOrders,
        timeline: currentState.timeline,
        newStatus: event.status,
      ));
      
      try {
        await _repository.updateIssueStatus(
          currentState.issue.id,
          event.status,
        );
        
        // Create a new issue with updated status
        final updatedIssue = currentState.issue.copyWith(
          status: event.status.toString().split('.').last,
        );
        
        // Refresh timeline after status update
        final updatedTimeline = await _repository.getTimelineForIssue(currentState.issue.id);
        
        emit(IncidentDetailsLoaded(
          issue: updatedIssue,
          workOrders: currentState.workOrders,
          timeline: updatedTimeline,
        ));
      } catch (e) {
        emit(IncidentDetailsError(e.toString()));
        
        // Go back to previous state if error
        emit(currentState);
      }
    }
  }

  Future<void> _onCreateWorkOrder(
    CreateWorkOrderEvent event,
    Emitter<IncidentDetailsState> emit,
  ) async {
    if (state is IncidentDetailsLoaded) {
      final currentState = state as IncidentDetailsLoaded;
      
      emit(WorkOrderUpdating(
        issue: currentState.issue,
        workOrders: currentState.workOrders,
        timeline: currentState.timeline,
      ));
      
      try {
        // Create new work order
        final workOrder = WorkOrderModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.title,
          description: event.description,
          status: 'created',
          dueDate: event.dueDate,
          assignedTo: event.assignedTo,
          estimatedCost: event.estimatedCost,
          createdAt: DateTime.now(),
          issueId: currentState.issue.id,
        );
        
        final updatedWorkOrders = await _repository.createWorkOrder(workOrder);
        
        // Refresh timeline after work order creation
        final updatedTimeline = await _repository.getTimelineForIssue(currentState.issue.id);
        
        emit(IncidentDetailsLoaded(
          issue: currentState.issue,
          workOrders: updatedWorkOrders,
          timeline: updatedTimeline,
        ));
      } catch (e) {
        emit(IncidentDetailsError(e.toString()));
        
        // Go back to previous state if error
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteWorkOrder(
    DeleteWorkOrderEvent event,
    Emitter<IncidentDetailsState> emit,
  ) async {
    if (state is IncidentDetailsLoaded) {
      final currentState = state as IncidentDetailsLoaded;
      
      emit(WorkOrderUpdating(
        issue: currentState.issue,
        workOrders: currentState.workOrders,
        timeline: currentState.timeline,
      ));
      
      try {
        final updatedWorkOrders = await _repository.deleteWorkOrder(
          currentState.issue.id,
          event.workOrderId,
        );
        
        // Refresh timeline after work order deletion
        final updatedTimeline = await _repository.getTimelineForIssue(currentState.issue.id);
        
        emit(IncidentDetailsLoaded(
          issue: currentState.issue,
          workOrders: updatedWorkOrders,
          timeline: updatedTimeline,
        ));
      } catch (e) {
        emit(IncidentDetailsError(e.toString()));
        
        // Go back to previous state if error
        emit(currentState);
      }
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<IncidentDetailsState> emit,
  ) async {
    if (state is IncidentDetailsLoaded) {
      final currentState = state as IncidentDetailsLoaded;
      
      emit(CommentAdding(
        issue: currentState.issue,
        workOrders: currentState.workOrders,
        timeline: currentState.timeline,
      ));
      
      try {
        // Create a new timeline entry for the comment
        final updatedTimeline = await _repository.addCommentToIssue(
          currentState.issue.id,
          event.comment,
        );
        
        emit(IncidentDetailsLoaded(
          issue: currentState.issue,
          workOrders: currentState.workOrders,
          timeline: updatedTimeline,
        ));
      } catch (e) {
        emit(IncidentDetailsError(e.toString()));
        
        // Go back to previous state if error
        emit(currentState);
      }
    }
  }
}

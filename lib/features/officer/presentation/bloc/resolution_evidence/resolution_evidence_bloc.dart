import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grampulse/features/officer/data/repositories/officer_repository.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/domain/models/resolution_model.dart';
import 'package:grampulse/features/officer/presentation/bloc/resolution_evidence/resolution_evidence_event.dart';
import 'package:grampulse/features/officer/presentation/bloc/resolution_evidence/resolution_evidence_state.dart';

class ResolutionEvidenceBloc extends Bloc<ResolutionEvidenceEvent, ResolutionEvidenceState> {
  final OfficerRepository _repository;
  
  ResolutionEvidenceBloc({
    required OfficerRepository repository,
    required IssueModel issue,
  }) : _repository = repository,
       super(ResolutionEvidenceInitial(issue: issue)) {
    on<AddBeforePhotoEvent>(_onAddBeforePhoto);
    on<RemoveBeforePhotoEvent>(_onRemoveBeforePhoto);
    on<RemoveNewBeforePhotoEvent>(_onRemoveNewBeforePhoto);
    on<AddAfterPhotoEvent>(_onAddAfterPhoto);
    on<RemoveAfterPhotoEvent>(_onRemoveAfterPhoto);
    on<RemoveNewAfterPhotoEvent>(_onRemoveNewAfterPhoto);
    on<UpdateCompletionDateEvent>(_onUpdateCompletionDate);
    on<SubmitResolutionEvent>(_onSubmitResolution);
  }
  
  void _onAddBeforePhoto(
    AddBeforePhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        newBeforePhotos: List.from(currentState.newBeforePhotos)..add(event.photo),
      ));
    }
  }
  
  void _onRemoveBeforePhoto(
    RemoveBeforePhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        beforePhotos: List.from(currentState.beforePhotos)..remove(event.photo),
      ));
    }
  }
  
  void _onRemoveNewBeforePhoto(
    RemoveNewBeforePhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        newBeforePhotos: List.from(currentState.newBeforePhotos)..remove(event.photo),
      ));
    }
  }
  
  void _onAddAfterPhoto(
    AddAfterPhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        newAfterPhotos: List.from(currentState.newAfterPhotos)..add(event.photo),
      ));
    }
  }
  
  void _onRemoveAfterPhoto(
    RemoveAfterPhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        afterPhotos: List.from(currentState.afterPhotos)..remove(event.photo),
      ));
    }
  }
  
  void _onRemoveNewAfterPhoto(
    RemoveNewAfterPhotoEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(
        newAfterPhotos: List.from(currentState.newAfterPhotos)..remove(event.photo),
      ));
    }
  }
  
  void _onUpdateCompletionDate(
    UpdateCompletionDateEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      emit(currentState.copyWith(completionDate: event.date));
    }
  }
  
  Future<void> _onSubmitResolution(
    SubmitResolutionEvent event,
    Emitter<ResolutionEvidenceState> emit,
  ) async {
    if (state is ResolutionEvidenceInitial) {
      final currentState = state as ResolutionEvidenceInitial;
      
      emit(ResolutionEvidenceSubmitting(
        issue: currentState.issue,
        beforePhotos: currentState.beforePhotos,
        newBeforePhotos: currentState.newBeforePhotos,
        afterPhotos: currentState.afterPhotos,
        newAfterPhotos: currentState.newAfterPhotos,
        completionDate: currentState.completionDate,
      ));
      
      try {
        // Upload new photos first
        // We're ignoring before photos for now, but keeping the upload logic for future use
        await _uploadPhotos(currentState.newBeforePhotos);
        final uploadedAfterPhotos = await _uploadPhotos(currentState.newAfterPhotos);
        
        // Create resolution model with all photos
        final resolution = ResolutionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          description: event.description,
          resolvedAt: currentState.completionDate ?? DateTime.now(),
          cost: event.cost,
          actionTaken: event.actionTaken,
          byOfficer: "Current Officer", // In real app, this would come from authentication
          // Combine existing and newly uploaded photos
          mediaUrls: [
            ...currentState.afterPhotos, 
            ...uploadedAfterPhotos
          ],
        );
        
        // Submit to repository
        final updatedIssue = await _repository.resolveIssue(
          currentState.issue.id,
          resolution,
        );
        
        emit(ResolutionEvidenceSuccess(
          issue: updatedIssue,
          resolution: resolution,
        ));
      } catch (error) {
        emit(ResolutionEvidenceFailure(
          issue: currentState.issue,
          errorMessage: error.toString(),
          beforePhotos: currentState.beforePhotos,
          newBeforePhotos: currentState.newBeforePhotos,
          afterPhotos: currentState.afterPhotos,
          newAfterPhotos: currentState.newAfterPhotos,
          completionDate: currentState.completionDate,
        ));
      }
    }
  }
  
  // Helper method to simulate uploading photos
  Future<List<MediaModel>> _uploadPhotos(List<File> photos) async {
    // In a real app, this would upload to a server and return URLs
    await Future.delayed(const Duration(seconds: 1));
    
    return photos.map((file) {
      return MediaModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        url: file.path,
        type: 'image',
        uploadedAt: DateTime.now(),
      );
    }).toList();
  }
}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';

abstract class ResolutionEvidenceEvent extends Equatable {
  const ResolutionEvidenceEvent();

  @override
  List<Object?> get props => [];
}

class AddBeforePhotoEvent extends ResolutionEvidenceEvent {
  final File photo;

  const AddBeforePhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.path];
}

class RemoveBeforePhotoEvent extends ResolutionEvidenceEvent {
  final MediaModel photo;

  const RemoveBeforePhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.id];
}

class RemoveNewBeforePhotoEvent extends ResolutionEvidenceEvent {
  final File photo;

  const RemoveNewBeforePhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.path];
}

class AddAfterPhotoEvent extends ResolutionEvidenceEvent {
  final File photo;

  const AddAfterPhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.path];
}

class RemoveAfterPhotoEvent extends ResolutionEvidenceEvent {
  final MediaModel photo;

  const RemoveAfterPhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.id];
}

class RemoveNewAfterPhotoEvent extends ResolutionEvidenceEvent {
  final File photo;

  const RemoveNewAfterPhotoEvent(this.photo);

  @override
  List<Object?> get props => [photo.path];
}

class UpdateCompletionDateEvent extends ResolutionEvidenceEvent {
  final DateTime? date;

  const UpdateCompletionDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class SubmitResolutionEvent extends ResolutionEvidenceEvent {
  final String description;
  final double? cost;
  final String? actionTaken;

  const SubmitResolutionEvent({
    required this.description,
    this.cost,
    this.actionTaken,
  });

  @override
  List<Object?> get props => [description, cost, actionTaken];
}

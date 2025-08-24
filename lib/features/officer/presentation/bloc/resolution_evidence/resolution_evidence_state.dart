import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:grampulse/features/officer/domain/models/issue_model.dart';
import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/domain/models/resolution_model.dart';

abstract class ResolutionEvidenceState extends Equatable {
  const ResolutionEvidenceState();
  
  @override
  List<Object?> get props => [];
}

class ResolutionEvidenceInitial extends ResolutionEvidenceState {
  final IssueModel issue;
  final List<MediaModel> beforePhotos;
  final List<File> newBeforePhotos;
  final List<MediaModel> afterPhotos;
  final List<File> newAfterPhotos;
  final DateTime? completionDate;
  
  const ResolutionEvidenceInitial({
    required this.issue,
    this.beforePhotos = const [],
    this.newBeforePhotos = const [],
    this.afterPhotos = const [],
    this.newAfterPhotos = const [],
    this.completionDate,
  });
  
  ResolutionEvidenceInitial copyWith({
    IssueModel? issue,
    List<MediaModel>? beforePhotos,
    List<File>? newBeforePhotos,
    List<MediaModel>? afterPhotos,
    List<File>? newAfterPhotos,
    DateTime? completionDate,
    bool clearCompletionDate = false,
  }) {
    return ResolutionEvidenceInitial(
      issue: issue ?? this.issue,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      newBeforePhotos: newBeforePhotos ?? this.newBeforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      newAfterPhotos: newAfterPhotos ?? this.newAfterPhotos,
      completionDate: clearCompletionDate ? null : (completionDate ?? this.completionDate),
    );
  }
  
  @override
  List<Object?> get props => [
    issue, 
    beforePhotos, 
    newBeforePhotos, 
    afterPhotos, 
    newAfterPhotos, 
    completionDate,
  ];
}

class ResolutionEvidenceSubmitting extends ResolutionEvidenceState {
  final IssueModel issue;
  final List<MediaModel> beforePhotos;
  final List<File> newBeforePhotos;
  final List<MediaModel> afterPhotos;
  final List<File> newAfterPhotos;
  final DateTime? completionDate;
  
  const ResolutionEvidenceSubmitting({
    required this.issue,
    this.beforePhotos = const [],
    this.newBeforePhotos = const [],
    this.afterPhotos = const [],
    this.newAfterPhotos = const [],
    this.completionDate,
  });
  
  @override
  List<Object?> get props => [
    issue, 
    beforePhotos, 
    newBeforePhotos, 
    afterPhotos, 
    newAfterPhotos, 
    completionDate,
  ];
}

class ResolutionEvidenceSuccess extends ResolutionEvidenceState {
  final IssueModel issue;
  final ResolutionModel resolution;
  
  const ResolutionEvidenceSuccess({
    required this.issue,
    required this.resolution,
  });
  
  @override
  List<Object> get props => [issue, resolution];
}

class ResolutionEvidenceFailure extends ResolutionEvidenceState {
  final IssueModel issue;
  final String errorMessage;
  final List<MediaModel> beforePhotos;
  final List<File> newBeforePhotos;
  final List<MediaModel> afterPhotos;
  final List<File> newAfterPhotos;
  final DateTime? completionDate;
  
  const ResolutionEvidenceFailure({
    required this.issue,
    required this.errorMessage,
    this.beforePhotos = const [],
    this.newBeforePhotos = const [],
    this.afterPhotos = const [],
    this.newAfterPhotos = const [],
    this.completionDate,
  });
  
  @override
  List<Object?> get props => [
    issue, 
    errorMessage, 
    beforePhotos, 
    newBeforePhotos, 
    afterPhotos, 
    newAfterPhotos, 
    completionDate,
  ];
}

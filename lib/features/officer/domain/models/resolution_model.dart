import 'package:grampulse/features/officer/domain/models/officer_models.dart';

class ResolutionModel {
  final String id;
  final String description;
  final DateTime? resolvedAt;
  final List<MediaModel> mediaUrls;
  final double? cost;
  final String? actionTaken;
  final String? byOfficer;

  const ResolutionModel({
    required this.id,
    required this.description,
    this.resolvedAt,
    this.mediaUrls = const [],
    this.cost,
    this.actionTaken,
    this.byOfficer,
  });
}

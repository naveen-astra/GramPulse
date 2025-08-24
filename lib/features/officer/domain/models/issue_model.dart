import 'package:grampulse/features/officer/domain/models/officer_models.dart';
import 'package:grampulse/features/officer/domain/models/resolution_model.dart';

class IssueModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final String category;
  final String submittedBy;
  final DateTime dateReported;
  final String status;
  final int urgency;
  final List<MediaModel> media;
  final ResolutionModel? resolution;
  final List<WorkOrderModel> workOrders;
  final String? adminArea;

  const IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.submittedBy,
    required this.dateReported,
    required this.status,
    required this.urgency,
    this.media = const [],
    this.resolution,
    this.workOrders = const [],
    this.adminArea,
  });

  IssueModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    double? latitude,
    double? longitude,
    String? category,
    String? submittedBy,
    DateTime? dateReported,
    String? status,
    int? urgency,
    List<MediaModel>? media,
    ResolutionModel? resolution,
    List<WorkOrderModel>? workOrders,
    String? adminArea,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      submittedBy: submittedBy ?? this.submittedBy,
      dateReported: dateReported ?? this.dateReported,
      status: status ?? this.status,
      urgency: urgency ?? this.urgency,
      media: media ?? this.media,
      resolution: resolution ?? this.resolution,
      workOrders: workOrders ?? this.workOrders,
      adminArea: adminArea ?? this.adminArea,
    );
  }
}

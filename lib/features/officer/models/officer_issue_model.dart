import 'package:equatable/equatable.dart';
import 'package:grampulse/features/map/domain/models/category_model.dart';

class OfficerIssueModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final CategoryModel category;
  final String status;
  final String priority;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final DateTime? updatedAt;
  final DateTime? slaDueAt;
  final double slaPercentage;
  final String? assignedTo;
  final String? location;
  
  const OfficerIssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.assignedAt,
    this.updatedAt,
    this.slaDueAt,
    required this.slaPercentage,
    this.assignedTo,
    this.location,
  });
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    status,
    priority,
    createdAt,
    assignedAt,
    updatedAt,
    slaDueAt,
    slaPercentage,
    assignedTo,
    location,
  ];
  
  OfficerIssueModel copyWith({
    String? id,
    String? title,
    String? description,
    CategoryModel? category,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? assignedAt,
    DateTime? updatedAt,
    DateTime? slaDueAt,
    double? slaPercentage,
    String? assignedTo,
    String? location,
  }) {
    return OfficerIssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      assignedAt: assignedAt ?? this.assignedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slaDueAt: slaDueAt ?? this.slaDueAt,
      slaPercentage: slaPercentage ?? this.slaPercentage,
      assignedTo: assignedTo ?? this.assignedTo,
      location: location ?? this.location,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grampulse/core/utils/l10n/app_localizations.dart';

class OfficerModel {
  final String id;
  final String name;
  final String designation;
  final String phone;
  final String? email;
  final String department;
  
  const OfficerModel({
    required this.id,
    required this.name,
    required this.designation,
    required this.phone,
    this.email,
    required this.department,
  });
}

class WorkOrderModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime dueDate;
  final String assignedTo;
  final double? estimatedCost;
  final double? actualCost;
  final DateTime createdAt;
  final String issueId;
  
  const WorkOrderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.assignedTo,
    this.estimatedCost,
    this.actualCost,
    required this.createdAt,
    required this.issueId,
  });
  
  static String getStatusLabel(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context);
    
    switch (status) {
      case 'created':
        return l10n.created;
      case 'assigned':
        return l10n.assigned;
      case 'in_progress':
        return l10n.inProgress;
      case 'completed':
        return l10n.completed;
      case 'cancelled':
        return l10n.cancelled;
      default:
        return status;
    }
  }
  
  static Color getStatusColor(String status) {
    switch (status) {
      case 'created':
        return Colors.blue;
      case 'assigned':
        return Colors.purple;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class MediaModel {
  final String id;
  final String url;
  final String type; // image, video, etc.
  final DateTime uploadedAt;
  final Map<String, dynamic>? metadata;
  
  const MediaModel({
    required this.id,
    required this.url,
    required this.type,
    required this.uploadedAt,
    this.metadata,
  });
}

class TimelineEntryModel {
  final String id;
  final String status;
  final String description;
  final DateTime timestamp;
  final String? updatedBy;
  final List<MediaModel>? media;
  
  const TimelineEntryModel({
    required this.id,
    required this.status,
    required this.description,
    required this.timestamp,
    this.updatedBy,
    this.media,
  });
}

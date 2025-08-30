import 'assignment.dart';

class OfficerDashboardStats {
  final int totalAssigned;
  final int newIncidents;
  final int inProgress;
  final int completed;
  final int pending;

  OfficerDashboardStats({
    required this.totalAssigned,
    required this.newIncidents,
    required this.inProgress,
    required this.completed,
    required this.pending,
  });

  factory OfficerDashboardStats.fromJson(Map<String, dynamic> json) {
    return OfficerDashboardStats(
      totalAssigned: json['totalAssigned'] ?? 0,
      newIncidents: json['newIncidents'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAssigned': totalAssigned,
      'newIncidents': newIncidents,
      'inProgress': inProgress,
      'completed': completed,
      'pending': pending,
    };
  }
}

class OfficerIncident {
  final String assignmentId;
  final AssignmentStatus assignmentStatus;
  final DateTime assignedAt;
  final String? notes;
  final IncidentDetails incident;

  OfficerIncident({
    required this.assignmentId,
    required this.assignmentStatus,
    required this.assignedAt,
    this.notes,
    required this.incident,
  });

  factory OfficerIncident.fromJson(Map<String, dynamic> json) {
    return OfficerIncident(
      assignmentId: json['assignmentId'],
      assignmentStatus: AssignmentStatus.fromString(json['assignmentStatus']),
      assignedAt: DateTime.parse(json['assignedAt']),
      notes: json['notes'],
      incident: IncidentDetails.fromJson(json['incident']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'assignmentStatus': assignmentStatus.value,
      'assignedAt': assignedAt.toIso8601String(),
      'notes': notes,
      'incident': incident.toJson(),
    };
  }
}

class IncidentDetails {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String status;
  final int severity;
  final IncidentLocation location;
  final List<String> media;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CitizenInfo citizen;

  IncidentDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.status,
    required this.severity,
    required this.location,
    required this.media,
    required this.createdAt,
    required this.updatedAt,
    required this.citizen,
  });

  factory IncidentDetails.fromJson(Map<String, dynamic> json) {
    return IncidentDetails(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['categoryId'],
      status: json['status'],
      severity: json['severity'],
      location: IncidentLocation.fromJson(json['location']),
      media: List<String>.from(json['media'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      citizen: CitizenInfo.fromJson(json['citizen']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'status': status,
      'severity': severity,
      'location': location.toJson(),
      'media': media,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'citizen': citizen.toJson(),
    };
  }

  String get severityName {
    switch (severity) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown';
    }
  }
}

class IncidentLocation {
  final double latitude;
  final double longitude;
  final String? address;

  IncidentLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory IncidentLocation.fromJson(Map<String, dynamic> json) {
    return IncidentLocation(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class CitizenInfo {
  final String? id;
  final String name;
  final String? phone;
  final String? profileImageUrl;

  CitizenInfo({
    this.id,
    required this.name,
    this.phone,
    this.profileImageUrl,
  });

  factory CitizenInfo.fromJson(Map<String, dynamic> json) {
    return CitizenInfo(
      id: json['id'],
      name: json['name'] ?? 'Anonymous',
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}

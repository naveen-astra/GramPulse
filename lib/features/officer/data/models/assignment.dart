class Assignment {
  final String id;
  final String incidentId;
  final String assigneeId;
  final String assignedById;
  final String role;
  final DateTime assignedAt;
  final DateTime? resolvedAt;
  final String? notes;
  final bool isCurrent;
  final AssignmentStatus status;

  Assignment({
    required this.id,
    required this.incidentId,
    required this.assigneeId,
    required this.assignedById,
    required this.role,
    required this.assignedAt,
    this.resolvedAt,
    this.notes,
    required this.isCurrent,
    required this.status,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? json['_id'],
      incidentId: json['incident'] ?? json['incidentId'],
      assigneeId: json['assignee'] ?? json['assigneeId'],
      assignedById: json['assignedBy'] ?? json['assignedById'],
      role: json['role'],
      assignedAt: DateTime.parse(json['assignedAt'] ?? json['createdAt']),
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt'])
          : null,
      notes: json['notes'],
      isCurrent: json['isCurrent'] ?? true,
      status: AssignmentStatus.fromString(json['status'] ?? 'ASSIGNED'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentId': incidentId,
      'assigneeId': assigneeId,
      'assignedById': assignedById,
      'role': role,
      'assignedAt': assignedAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'notes': notes,
      'isCurrent': isCurrent,
      'status': status.value,
    };
  }

  @override
  String toString() {
    return 'Assignment(id: $id, status: ${status.value}, current: $isCurrent)';
  }
}

enum AssignmentStatus {
  assigned('ASSIGNED'),
  accepted('ACCEPTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  rejected('REJECTED');

  const AssignmentStatus(this.value);
  final String value;

  static AssignmentStatus fromString(String value) {
    return AssignmentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AssignmentStatus.assigned,
    );
  }

  String get displayName {
    switch (this) {
      case AssignmentStatus.assigned:
        return 'Assigned';
      case AssignmentStatus.accepted:
        return 'Accepted';
      case AssignmentStatus.inProgress:
        return 'In Progress';
      case AssignmentStatus.completed:
        return 'Completed';
      case AssignmentStatus.rejected:
        return 'Rejected';
    }
  }
}

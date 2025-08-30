import 'department.dart';

class OfficerProfile {
  final String id;
  final String userId;
  final Department? departmentDetails;
  final String jurisdictionId;
  final String designation;
  final int escalationLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfficerProfile({
    required this.id,
    required this.userId,
    this.departmentDetails,
    required this.jurisdictionId,
    required this.designation,
    required this.escalationLevel,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfficerProfile.fromJson(Map<String, dynamic> json) {
    return OfficerProfile(
      id: json['id'] ?? json['_id'],
      userId: json['user'] ?? json['userId'],
      departmentDetails: json['departmentDetails'] != null 
          ? Department.fromJson(json['departmentDetails'])
          : null,
      jurisdictionId: json['jurisdictionId'],
      designation: json['designation'],
      escalationLevel: json['escalationLevel'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'departmentDetails': departmentDetails?.toJson(),
      'jurisdictionId': jurisdictionId,
      'designation': designation,
      'escalationLevel': escalationLevel,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get escalationLevelName {
    switch (escalationLevel) {
      case 1:
        return 'Field Officer';
      case 2:
        return 'Nodal Officer';
      case 3:
        return 'Head Officer';
      default:
        return 'Officer';
    }
  }

  @override
  String toString() {
    return 'OfficerProfile(id: $id, designation: $designation, escalation: $escalationLevelName)';
  }
}

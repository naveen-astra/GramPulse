class Department {
  final String id;
  final String name;
  final String code;
  final String? description;
  final int jurisdictionLevel;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.jurisdictionLevel,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      jurisdictionLevel: json['jurisdictionLevel'],
      parentId: json['parentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'jurisdictionLevel': jurisdictionLevel,
      'parentId': parentId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Department(id: $id, name: $name, code: $code, level: $jurisdictionLevel)';
  }
}

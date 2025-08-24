class CitizenModel {
  final String id;
  final String name;
  final String phone;
  final DateTime? lastAssistedAt;
  final int assistCount;
  
  const CitizenModel({
    required this.id,
    required this.name,
    required this.phone,
    this.lastAssistedAt,
    this.assistCount = 0,
  });

  CitizenModel copyWith({
    String? id,
    String? name,
    String? phone,
    DateTime? lastAssistedAt,
    int? assistCount,
  }) {
    return CitizenModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      lastAssistedAt: lastAssistedAt ?? this.lastAssistedAt,
      assistCount: assistCount ?? this.assistCount,
    );
  }
}

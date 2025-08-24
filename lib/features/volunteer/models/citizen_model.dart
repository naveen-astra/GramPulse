import 'package:equatable/equatable.dart';

class CitizenModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final DateTime lastAssistedAt;
  final int assistCount;

  const CitizenModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.lastAssistedAt,
    required this.assistCount,
  });

  @override
  List<Object?> get props => [id, name, phone, lastAssistedAt, assistCount];
}

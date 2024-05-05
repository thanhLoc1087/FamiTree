import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final bool deleted;
  const Job({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.deleted = false,
  });

  @override
  List<Object> get props => [id, name, description, quantity, deleted];

  Job copyWith({
    String? id,
    String? name,
    String? description,
    int? quantity,
    bool? deleted,
  }) {
    return Job(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool get stringify => true;
}

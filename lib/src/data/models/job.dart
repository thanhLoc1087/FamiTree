import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String name;
  final String description;
  const Job({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];

  Job copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Job(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool get stringify => true;
}

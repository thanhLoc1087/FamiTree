// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'deleted': deleted,
    };
  }

  factory Job.fromJson({
    String? id,
    required Map<String, dynamic> json
  }) {
    return Job(
      id: id ?? cvToString(json['id']),
      name: cvToString(json['name']),
      description: cvToString(json['description']),
      quantity: cvToInt(json['quantity']),
      deleted: cvToBool(json['deleted']),
    );
  }
}

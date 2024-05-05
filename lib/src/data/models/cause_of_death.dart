// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

class CauseOfDeath extends Equatable {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final bool deleted;
  const CauseOfDeath({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.deleted = false,
  });

  @override
  List<Object> get props => [id, name, description, quantity, deleted];

  CauseOfDeath copyWith({
    String? id,
    String? name,
    String? description,
    bool? deleted,
    int? quantity,
  }) {
    return CauseOfDeath(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'deleted': deleted,
      'quantity': quantity,
    };
  }

  factory CauseOfDeath.fromMap(Map<String, dynamic> map) {
    return CauseOfDeath(
      id: cvToString(map['id']),
      name: cvToString(map['name']),
      description: cvToString(map['description']), 
      deleted: cvToBool(map['deleted']),
      quantity: cvToInt(map['quantity']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CauseOfDeath.fromJson(String source) => CauseOfDeath.fromMap(json.decode(source) as Map<String, dynamic>);
}

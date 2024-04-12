// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CauseOfDeath extends Equatable {
  final String id;
  final String name;
  final String description;
  const CauseOfDeath({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];

  CauseOfDeath copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return CauseOfDeath(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory CauseOfDeath.fromMap(Map<String, dynamic> map) {
    return CauseOfDeath(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CauseOfDeath.fromJson(String source) => CauseOfDeath.fromMap(json.decode(source) as Map<String, dynamic>);
}

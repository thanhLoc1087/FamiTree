// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class RelationshipType extends Equatable {
  final String id;
  final String name;
  final String description;
  const RelationshipType({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];

  RelationshipType copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return RelationshipType(
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

  factory RelationshipType.fromMap(Map<String, dynamic> map) {
    return RelationshipType(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RelationshipType.fromJson(String source) => RelationshipType.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

class AchievementType extends Equatable {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final bool deleted;
  const AchievementType({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    this.deleted = false,
  });

  @override
  List<Object> get props => [id, name, description, quantity, deleted];

  AchievementType copyWith({
    String? id,
    String? name,
    String? description,
    bool? deleted,
    int? quantity,
  }) {
    return AchievementType(
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

  factory AchievementType.fromMap(Map<String, dynamic> map) {
    return AchievementType(
      id: cvToString(map['id']),
      name: cvToString(map['name']),
      description: cvToString(map['description']),
      deleted: cvToBool(map['deleted']),
      quantity: cvToInt(map['quantity']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AchievementType.fromJson(String source) => AchievementType.fromMap(json.decode(source) as Map<String, dynamic>);
}

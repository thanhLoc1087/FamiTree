// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FamilyTree extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  const FamilyTree({
    required this.id,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  FamilyTree copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return FamilyTree(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
    };
  }

  factory FamilyTree.fromMap(Map<String, dynamic> map) {
    return FamilyTree(
      id: map['id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(map['lastUpdatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyTree.fromJson(String source) => FamilyTree.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, createdAt, lastUpdatedAt];
}

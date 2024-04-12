// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/data/models/member.dart';

import 'relationship_type.dart';

class Relationship extends Equatable {
  final RelationshipType type;
  final Member member;
  final DateTime time;
  const Relationship({
    required this.type,
    required this.member,
    required this.time,
  });
  

  Relationship copyWith({
    RelationshipType? type,
    Member? member,
    DateTime? time,
  }) {
    return Relationship(
      type: type ?? this.type,
      member: member ?? this.member,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toMap(),
      'member': member.toMap(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Relationship.fromMap(Map<String, dynamic> map) {
    return Relationship(
      type: RelationshipType.fromMap(map['type'] as Map<String,dynamic>),
      member: Member.fromMap(map['member'] as Map<String,dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Relationship.fromJson(String source) => Relationship.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, member, time];
}

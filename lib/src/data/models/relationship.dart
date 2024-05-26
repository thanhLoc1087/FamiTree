// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.toJsonWithId(),
      'member': member.toJson(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      type: RelationshipType.fromJson(json: json['type'] as Map<String,dynamic>),
      member: Member.fromJson(null, json['member'] as Map<String,dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] as int),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, member, time];
}

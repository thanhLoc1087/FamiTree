// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:famitree/src/data/models/achievement_type.dart';

class Achievement extends Equatable {
  final AchievementType type;
  final DateTime time;
  const Achievement({
    required this.type,
    required this.time,
  });

  Achievement copyWith({
    AchievementType? type,
    DateTime? time,
  }) {
    return Achievement(
      type: type ?? this.type,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toMap(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      type: AchievementType.fromMap(map['type'] as Map<String,dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Achievement.fromJson(String source) => Achievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, time];
}

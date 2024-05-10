// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.toJsonWithId(),
      'time': time,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      type: AchievementType.fromJson(json: json['type'] as Map<String,dynamic>),
      time: cvToDate(json['time']),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, time];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/place.dart';

class Death extends Equatable {
  final CauseOfDeath cause;
  final Place place;
  final DateTime time;
  const Death({
    required this.cause,
    required this.place,
    required this.time,
  });

  Death copyWith({
    CauseOfDeath? cause,
    Place? place,
    DateTime? time,
  }) {
    return Death(
      cause: cause ?? this.cause,
      place: place ?? this.place,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cause': cause.toMap(),
      'place': place.toJson(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Death.fromMap(Map<String, dynamic> map) {
    return Death(
      cause: CauseOfDeath.fromMap(map['cause'] as Map<String,dynamic>),
      place: Place.fromJSon(json: map['place'] as Map<String,dynamic>),
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Death.fromJson(String source) => Death.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [cause, place, time];
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cause': cause.toJsonWithId(),
      'place': place.toJson(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Death.fromJson(Map<String, dynamic> map) {
    return Death(
      cause: CauseOfDeath.fromJson(json: map['cause'] as Map<String,dynamic>),
      place: Place.fromJson(json: map['place'] as Map<String,dynamic>),
      time: cvToDate(map['time']),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [cause, place, time];
}

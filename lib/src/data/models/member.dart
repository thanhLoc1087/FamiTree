// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'achievement.dart';
import 'death.dart';
import 'place.dart';
import 'relationship.dart';

class Member extends Equatable {
  final String name;
  final Relationship? relationship;
  final Place homeland;
  final List<Achievement> achievements;
  final Death? death;
  
  const Member({
    required this.name,
    required this.relationship,
    required this.homeland,
    this.achievements = const [],
    this.death,
  });

  Member copyWith({
    String? name,
    Relationship? relationship,
    Place? homeland,
    List<Achievement>? achievements,
    Death? death,
  }) {
    return Member(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      homeland: homeland ?? this.homeland,
      achievements: achievements ?? this.achievements,
      death: death ?? this.death,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      relationship,
      homeland,
      achievements,
      death,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'relationship': relationship?.toMap(),
      'homeland': homeland.toMap(),
      'achievements': achievements.map((x) => x.toMap()).toList(),
      'death': death?.toMap(),
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'] as String,
      relationship: Relationship.fromMap(map['relationship'] as Map<String,dynamic>),
      homeland: Place.fromMap(map['homeland'] as Map<String,dynamic>),
      achievements: List<Achievement>.from((map['achievements'] as List<int>).map<Achievement>((x) => Achievement.fromMap(x as Map<String,dynamic>),),),
      death: map['death'] != null ? Death.fromMap(map['death'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source) as Map<String, dynamic>);
}

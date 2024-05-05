// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:famitree/src/data/models/family_tree.dart';

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
  final FamilyTree tree;
  
  const Member({
    required this.name,
    this.relationship,
    required this.homeland,
    this.achievements = const [],
    this.death,
    required this.tree,
  });

  Member copyWith({
    String? name,
    Relationship? relationship,
    Place? homeland,
    List<Achievement>? achievements,
    Death? death,
    FamilyTree? tree,
  }) {
    return Member(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      homeland: homeland ?? this.homeland,
      achievements: achievements ?? this.achievements,
      death: death ?? this.death,
      tree: tree ?? this.tree,
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
      tree,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'relationship': relationship?.toMap(),
      'homeland': homeland.toJson(),
      'achievements': achievements.map((x) => x.toMap()).toList(),
      'death': death?.toMap(),
      'tree': tree.toMap(),
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'] as String,
      relationship: map['relationship'] != null ? Relationship.fromMap(map['relationship'] as Map<String,dynamic>) : null,
      homeland: Place.fromJSon(json: map['homeland'] as Map<String,dynamic>),
      achievements: List<Achievement>.from((map['achievements'] as List<int>).map<Achievement>((x) => Achievement.fromMap(x as Map<String,dynamic>),),),
      death: map['death'] != null ? Death.fromMap(map['death'] as Map<String,dynamic>) : null,
      tree: FamilyTree.fromMap(map['tree'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source) as Map<String, dynamic>);
}

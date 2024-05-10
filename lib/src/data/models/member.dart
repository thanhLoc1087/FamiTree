// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'relationship': relationship?.toJson(),
      'homeland': homeland.toJson(),
      'achievements': achievements.map((x) => x.toJson()).toList(),
      'death': death?.toJson(),
      'tree': tree.toMap(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] as String,
      relationship: json['relationship'] != null ? Relationship.fromJson(json['relationship'] as Map<String,dynamic>) : null,
      homeland: Place.fromJson(json: json['homeland'] as Map<String,dynamic>),
      achievements: List<Achievement>.from((json['achievements'] as List<int>).map<Achievement>((x) => Achievement.fromJson(x as Map<String,dynamic>),),),
      death: json['death'] != null ? Death.fromJson(json['death'] as Map<String,dynamic>) : null,
      tree: FamilyTree.fromMap(json['tree'] as Map<String,dynamic>),
    );
  }
}

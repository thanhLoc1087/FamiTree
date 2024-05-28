// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'achievement.dart';
import 'death.dart';
import 'job.dart';
import 'place.dart';
import 'relationship.dart';

// ignore: must_be_immutable
class Member extends Equatable {
  final String id;
  final String name;
  final Relationship? relationship;
  final Place homeland;
  final Job job;
  final List<Achievement> achievements;
  Death? death;
  final String treeCode;
  final DateTime birthday;
  final String? image;
  Member? spouse;
  List<Member>? children;
  List<Member>? pastSpouses;
  List<Member>? parents;
  final bool isMale;

  void deleteDeath() {
    death = null;
  }

  void setSpouse(Member spouse) {
    this.spouse = spouse;
  }

  void addChild(Member child) {
    children ??=[];
    children!.add(child);
  }

  void addPastSppouse(Member spouse) {
    pastSpouses ??=[];
    pastSpouses!.add(spouse);
  }

  void addParent(Member spouse) {
    parents ??=[];
    parents!.add(spouse);
  }

  bool get isDead => death != null;

  bool get isNotInLaw => relationship == null || relationship!.type.id == 'child';
  
  Member({
    this.spouse, 
    this.children, 
    this.pastSpouses,
    this.parents,
    required this.id,
    required this.name,
    this.relationship,
    required this.homeland,
    this.achievements = const [],
    this.death,
    required this.job,
    required this.treeCode,
    required this.birthday,
    required this.isMale,
    this.image,
  });

  Member copyWith({
    Member? spouse,
    List<Member>? children,
    List<Member>? pastSpouses,
    List<Member>? parents,
    String? id,
    String? name,
    Relationship? relationship,
    Place? homeland,
    List<Achievement>? achievements,
    Death? death,
    String? treeCode,
    DateTime? birthday,
    Job? job,
    String? image,
    bool? isMale,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      homeland: homeland ?? this.homeland,
      achievements: achievements ?? this.achievements,
      death: death ?? this.death,
      treeCode: treeCode ?? this.treeCode,
      birthday: birthday ?? this.birthday,
      job: job ?? this.job,
      image: image ?? this.image,
      isMale: isMale ?? this.isMale,
      spouse: spouse ?? this.spouse,
      children: children ?? this.children,
      pastSpouses: pastSpouses ?? this.pastSpouses,
      parents: parents ?? this.parents,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      relationship,
      homeland,
      achievements,
      death,
      treeCode,
      birthday,
      job,
      image,
      isMale,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'relationship': relationship?.toJson(),
      'homeland': homeland.toJson(),
      'achievements': achievements.map((x) => x.toJson()).toList(),
      'job': job.toJson(),
      'death': death?.toJson(),
      'tree_code': treeCode,
      'birthday': birthday,
      'image': image,
      'is_male': isMale,
    };
  }

  factory Member.fromJson(String? id, Map<String, dynamic> json) {
    return Member(
      id: id ?? json['id'],
      name: cvToString(json['name']),
      relationship: json['relationship'] != null ? Relationship.fromJson(json['relationship'] as Map<String,dynamic>) : null,
      homeland: Place.fromJson(json: json['homeland'] as Map<String,dynamic>),
      job: Job.fromJson(json: json['job'] as Map<String,dynamic>),
      achievements: List.from((json['achievements'] as List).map((x) => Achievement.fromJson(x as Map<String,dynamic>),),),
      death: json['death'] != null ? Death.fromJson(json['death'] as Map<String,dynamic>) : null,
      treeCode: cvToString(json['tree_code']),
      image: cvToString(json['image']),
      isMale: cvToBool(json['is_male']),
      birthday: cvToDate(json['birthday']),
    );
  }
}

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/member.dart';

class FamilyTree extends Equatable {
  final String id;
  final String name;
  final String treeCode;
  final String viewCode;
  final List<String> editors;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool deleted;
  final Member? firstMember;
  const FamilyTree({
    required this.id,
    required this.name,
    required this.treeCode,
    required this.viewCode,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.firstMember,
    this.deleted = false,
    this.editors = const [],
  });

  FamilyTree copyWith({
    String? id,
    String? name,
    String? treeCode,
    String? viewCode,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    List<String>? editors,
    bool? deleted,
    Member? firstMember,
  }) {
    return FamilyTree(
      id: id ?? this.id,
      firstMember: firstMember ?? this.firstMember,
      name: name ?? this.name,
      treeCode: treeCode ?? this.treeCode,
      viewCode: viewCode ?? this.viewCode,
      editors: editors ?? this.editors,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'editors': editors,
      'treeCode': treeCode,
      'viewCode': viewCode,
      'createdAt': createdAt,
      'lastUpdatedAt': lastUpdatedAt,
      'deleted': deleted,
    };
  }

  factory FamilyTree.fromJson({
    required String id, 
    required Map<String, dynamic> map,
    required Member firstMember,
  }) {
    return FamilyTree(
      id: id,
      name: cvToString(map['name']),
      treeCode: cvToString(map['treeCode']),
      viewCode: cvToString(map['viewCode']),
      createdAt: cvToDate(map['createdAt']),
      lastUpdatedAt: cvToDate(map['lastUpdatedAt']),
      editors: <String>[...map['editors']],
      deleted: map['deleted'],
      firstMember: firstMember,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, treeCode, viewCode, createdAt, lastUpdatedAt, deleted, firstMember];
}

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

class FamilyTree extends Equatable {
  final String id;
  final String name;
  final String treeCode;
  final List<String> editors;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final bool deleted;
  const FamilyTree({
    required this.id,
    required this.name,
    required this.treeCode,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.deleted = false,
    this.editors = const [],
  });

  FamilyTree copyWith({
    String? id,
    String? name,
    String? treeCode,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    List<String>? editors,
    bool? deleted,
  }) {
    return FamilyTree(
      id: id ?? this.id,
      name: name ?? this.name,
      treeCode: treeCode ?? this.treeCode,
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
      'createdAt': createdAt,
      'lastUpdatedAt': lastUpdatedAt,
      'deleted': deleted,
    };
  }

  factory FamilyTree.fromJson(String id, Map<String, dynamic> map) {
    return FamilyTree(
      id: id,
      name: cvToString(map['name']),
      treeCode: cvToString(map['treeCode']),
      createdAt: cvToDate(map['createdAt']),
      lastUpdatedAt: cvToDate(map['lastUpdatedAt']),
      editors: map['editors'],
      deleted: map['deleted'],
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, treeCode, createdAt, lastUpdatedAt, deleted];
}

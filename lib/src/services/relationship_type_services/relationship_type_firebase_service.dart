import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/pair.dart';
import 'package:famitree/src/data/models/relationship_type.dart';

class RelationshipTypeRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.relationshipTypes);

  Future<List<RelationshipType>> getAllRelationshipTypes() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<RelationshipType> causes = result.docs
        .map((e) => RelationshipType.fromJson(id: e.id, json: e.data()))
        .toList();

    return causes;
  }

  Future<RelationshipType?> getRelationshipTypeById(String typeId) async {
    final data = await _ref
        .doc(typeId)
        .get();
    if (data.exists) {
      return RelationshipType.fromJson(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addRelationshipType(
    // 1 - tạo thành công
    // 0 - that bai
    RelationshipType type
  ) async {
    try {
      final countExistedName =
          await countExistingNames(type.name.trim());
      if (countExistedName.a + countExistedName.b > 0) {
        return false;
      }
      await _ref.add(type.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Future<Pair> countExistingNames(String typeName) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _ref
        .where("name", isEqualTo: typeName)
        .get();
    int countDeleted = 0;
    int countUndeleted = 0;
    for (var doc in result.docs) {
      if (cvToBool(doc['deleted'], false)) {
        countDeleted++;
      } else {
        countUndeleted++;
      }
    }
    return Pair(countDeleted, countUndeleted);
  }

  Future<int> updateRelationshipType(
    RelationshipType type, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(type.id).update(updateData);
    } else {
      await _ref.doc(type.id).update(type.toJson());
    }
    return 1;
  }

  Future<int> deleteRelationshipType(
    RelationshipType type
  ) async {
    final res = await updateRelationshipType(
      type,
      updateData: {"deleted": true});
    return res;
  }
}

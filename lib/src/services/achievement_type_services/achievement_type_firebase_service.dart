import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/pair.dart';

class AchievementTypeRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.achievementTypes);

  Future<List<AchievementType>> getAllAchievementTypes() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<AchievementType> causes = result.docs
        .map((e) => AchievementType.fromJson(id: e.id, json: e.data()))
        .toList();

    return causes;
  }

  Future<AchievementType?> getAchievementTypeById(String typeId) async {
    final data = await _ref
        .doc(typeId)
        .get();
    if (data.exists) {
      return AchievementType.fromJson(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addAchievementType(
    // 1 - tạo thành công
    // 0 - that bai
    AchievementType type
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

  Future<int> updateAchievementType(
    AchievementType type, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(type.id).update(updateData);
    } else {
      await _ref.doc(type.id).update(type.toJson());
    }
    return 1;
  }

  Future<int> deleteAchievementType(
    AchievementType type
  ) async {
    final res = await updateAchievementType(
      type,
      updateData: {"deleted": true});
    return res;
  }
}

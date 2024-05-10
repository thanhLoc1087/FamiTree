import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/pair.dart';

class DeathCauseRemoteService {
  final _deathRef =
      FirebaseFirestore.instance.collection(AppCollections.deathCauses);

  Future<List<CauseOfDeath>> getAllDeathCauses() async {
    final result = await _deathRef
        .where("deleted", isEqualTo: false)
        .get();

    List<CauseOfDeath> causes = result.docs
        .map((e) => CauseOfDeath.fromJson(id: e.id, json: e.data()))
        .toList();

    return causes;
  }

  Future<CauseOfDeath?> getDeathCauseById(String deathId) async {
    final data = await _deathRef
        .doc(deathId)
        .get();
    if (data.exists) {
      return CauseOfDeath.fromJson(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addDeathCause(
    // 1 - tạo thành công
    // 0 - that bai
    CauseOfDeath death
  ) async {
    try {
      final countExistedName =
          await countExistingNames(death.name.trim());
      if (countExistedName.a + countExistedName.b > 0) {
        return false;
      }
      await _deathRef.add(death.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Future<Pair> countExistingNames(String deathCauseName) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _deathRef
        .where("name", isEqualTo: deathCauseName)
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

  Future<int> updateDeathCause(
    CauseOfDeath deathCause, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _deathRef.doc(deathCause.id).update(updateData);
    } else {
      await _deathRef.doc(deathCause.id).update(deathCause.toJson());
    }
    return 1;
  }

  Future<int> deleteDeathCause(
    CauseOfDeath deathCause
  ) async {
    final res = await updateDeathCause(
      deathCause,
      updateData: {"deleted": true});
    return res;
  }
}

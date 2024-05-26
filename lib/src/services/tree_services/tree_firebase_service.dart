import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/pair.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/member_services/member_firebase_service.dart';

class TreeRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.trees);

  Future<List<FamilyTree>> getAllTrees() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<FamilyTree> causes = result.docs
        .map((e) => FamilyTree.fromJson(e.id, e.data()))
        .toList();

    return causes;
  }

  Future<FamilyTree?> getTreeById(String id) async {
    final data = await _ref
        .doc(id)
        .get();
    if (data.exists) {
      return FamilyTree.fromJson(data.id, data.data()!);
    }
    return null;
  }

  Future<FamilyTree?> getTreeByCode(String code) async {
    final data = await _ref
        .where("code", isEqualTo: code)
        .limit(1)
        .get();
    if (data.size == 1) {
      return FamilyTree.fromJson(data.docs.first.id, data.docs.first.data());
    }
    return null;
  }

  Future<bool> addTree(
    // 1 - tạo thành công
    // 0 - that bai
    MyUser user,
    FamilyTree tree,
    Member firstMember,
  ) async {
    try {
      final countExistedCode =
          await countExistingCodes(tree.name.trim());
      if (countExistedCode.a + countExistedCode.b > 0) {
        return false;
      }
      
      bool failed = false;
      final memberId = await MemberRemoteService().addMember(firstMember);
      failed = memberId == null;

      if (!failed) {
        await Future.wait([
          _ref.add(tree.copyWith(editors: [memberId]).toJson()),
          MyUser.updateTreeCode(user, tree.treeCode),
        ]);
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
  
  Future<Pair> countExistingCodes(String treeCode) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _ref
        .where("code", isEqualTo: treeCode)
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

  Future<int> updateTree(
    FamilyTree tree, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(tree.id).update(updateData);
    } else {
      await _ref.doc(tree.id).update(tree.toJson());
    }
    return 1;
  }

  Future<int> deleteTree(
    FamilyTree tree
  ) async {
    final res = await updateTree(
      tree,
      updateData: {"deleted": true});
    return res;
  }
}

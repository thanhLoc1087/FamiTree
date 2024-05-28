import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/pair.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/member_services/member_firebase_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';

class TreeRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.trees);
  final _memberService = MemberRemoteService();

  // Future<List<FamilyTree>> getAllTrees() async {
  //   final result = await _ref
  //       .where("deleted", isEqualTo: false)
  //       .get();

  //   List<FamilyTree> causes = result.docs
  //       .map((e) => FamilyTree.fromJson(id: e.id, map: e.data()))
  //       .toList();

  //   return causes;
  // }

  Future<FamilyTree?> getTreeById(String id) async {
    final data = await _ref
        .doc(id)
        .get();
    if (data.exists) {
      final treeCode = cvToString(data['treeCode']);
      if (treeCode.isEmpty) {
        return null;
      }
      final member = await getFirstMember(treeCode);
      if (member != null) {
        return FamilyTree.fromJson(id: data.id, map: data.data()!, firstMember: member);
      }
    }
    return null;
  }

  Future<FamilyTree?> getTreeByCode(String code) async {
    final data = await _ref
        .where("treeCode", isEqualTo: code)
        .limit(1)
        .get();
    final member = await getFirstMember(code);
    if (data.size == 1 && member != null) {
      return FamilyTree.fromJson(
        id: data.docs.first.id, 
        map: data.docs.first.data(),
        firstMember: member
      );
    }
    return null;
  }

  Future<FamilyTree?> getTreeByViewCode(String code) async {
    final data = await _ref
        .where("viewCode", isEqualTo: code)
        .limit(1)
        .get();
    if (data.size == 1) {
      final member = await getFirstMember(data.docs.first.data()['treeCode']);
      if (member != null) {
        return FamilyTree.fromJson(
        id: data.docs.first.id, 
        map: data.docs.first.data(),
        firstMember: member
      );
      }
    }
    return null;
  }

  Future<Member?> getFirstMember(String treeCode) async {
    final members = await _memberService.getMembersByTreeCode(treeCode);
    final mapMember = <String, Member> {
      for(var member in members)
        member.id: member
    };
    Member? firstMember;
    for (var mem in members) {
      final relationship = mem.relationship;
      if (relationship == null) {
        firstMember = mem;
      } else if (relationship.type.id == "spouse") {
        if (mapMember[relationship.member.id] != null) {
          mem.setSpouse(mapMember[relationship.member.id]!);
          if (mem.isDead) {
            mapMember[relationship.member.id]?.addPastSppouse(mem);
          } else {
            mapMember[relationship.member.id]?.setSpouse(mem);
          }
        }
      }
    }
    for (var mem in members) {
      final relationship = mem.relationship;
      if (relationship == null) {
        firstMember = mem;
      } else if (relationship.type.id == "child") {
        mapMember[relationship.member.id]?.addChild(mem);
        if (mapMember[relationship.member.id] != null) {
          mem.addParent(mapMember[relationship.member.id]!);
          if (mapMember[relationship.member.id]?.spouse != null) {
            mem.addParent(mapMember[relationship.member.id]!.spouse!);
            mapMember[relationship.member.id]?.spouse?.addChild(mem);
          }
          for (var past in mapMember[relationship.member.id]?.pastSpouses ?? []) {
            mem.addParent(past);
            past.addChild(mem);
          }
        }
      }
    }
    return firstMember;
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
      final countExistedViewCode =
          await countExistingViewCodes(tree.name.trim());
      if (countExistedViewCode.a + countExistedViewCode.b > 0) {
        return false;
      }
      
      bool failed = false;
      final memberId = await _memberService.addMember(firstMember);
      failed = memberId == null;

      if (!failed) {
        await Future.wait([
          _ref.add(tree.copyWith(editors: [CurrentUser().user.uid]).toJson()),
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
        .where("treeCode", isEqualTo: treeCode)
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
  
  Future<Pair> countExistingViewCodes(String treeCode) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _ref
        .where("viewCode", isEqualTo: treeCode)
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

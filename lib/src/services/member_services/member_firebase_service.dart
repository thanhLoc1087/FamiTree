import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/member.dart';

class MemberRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.members);

  Future<List<Member>> getAllMembers() async {
    final result = await _ref
        .where("deleted", isEqualTo: false)
        .get();

    List<Member> items = result.docs
        .map((e) => Member.fromJson(e.id, e.data()))
        .toList();

    return items;
  }

  Future<List<Member>> getMembersByTreeCode(String code) async {
    if (code.isEmpty) return [];
    final result = await _ref
        .where("tree_code", isEqualTo: code)
        .get();

    List<Member> items = result.docs
        .map((e) => Member.fromJson(e.id, e.data()))
        .toList();

    return items;
  }

  Future<Member?> getMemberById(String id) async {
    final data = await _ref
        .doc(id)
        .get();
    if (data.exists) {
      return Member.fromJson(data.id, data.data()!);
    }
    return null;
  }

  Future<String?> addMember(
    // 1 - tạo thành công
    // 0 - that bai
    Member item,
  ) async {
    try {
      final doc = await _ref.add(item.toJson());
      return doc.id;
    } catch (_) {
      return null;
    }
  }

  Future<int> updateMember(
    Member item, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _ref.doc(item.id).update(updateData);
    } else {
      await _ref.doc(item.id).update(item.toJson());
    }
    return 1;
  }

  Future<int> addDeath(
    Member item, 
    Death death,
  ) async {
    item.copyWith(
      death: death
    );
    await _ref.doc(item.id).update(item.toJson());
    return 1;
  }

  Future<int> addAchievement(
    Member item, 
    Achievement achievement,
  ) async {
    item.copyWith(
      achievements: [...item.achievements, achievement.copyWith(
        id: item.achievements.length.toString()
      )]
    );
    await _ref.doc(item.id).update(item.toJson());
    return 1;
  }

  Future<int> updateAchievement(
    Member item, 
    Achievement achievement,
  ) async {
    Achievement? updateAchievement;
    for (var acm in item.achievements) {
      if (acm.id == achievement.id) {
        updateAchievement = acm;
        break;
      }
    }
    final newAchievements = [...item.achievements..remove(updateAchievement), achievement];
    newAchievements.sort((a, b) => a.time.compareTo(b.time));
    if (updateAchievement != null) {
      item.copyWith(
        achievements: newAchievements
      );
      await _ref.doc(item.id).update(item.toJson());
    }
    return 1;
  }

  Future<int> deleteMember(
    Member member
  ) async {
    final res = await updateMember(
      member,
      updateData: {"deleted": true});
    return res;
  }
}

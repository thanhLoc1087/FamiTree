import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/services/achievement_type_services/achievement_type_firebase_service.dart';
import 'package:famitree/src/services/death_cause_services/death_cause_firebase_service.dart';
import 'package:famitree/src/services/relationship_type_services/relationship_type_firebase_service.dart';

class MemberRemoteService {
  final _ref =
      FirebaseFirestore.instance.collection(AppCollections.members);

  final _relationshipService = RelationshipTypeRemoteService();
  final _achievementService = AchievementTypeRemoteService();
  final _deathService = DeathCauseRemoteService();

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
      final relationshipType = item.relationship?.type;
      if (relationshipType != null) {
        await _relationshipService.updateRelationshipType(
          relationshipType.copyWith(quantity: relationshipType.quantity + 1)
        );
      }
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
    final deathCause = death.cause;
    await _deathService.updateDeathCause(
      deathCause.copyWith(quantity: deathCause.quantity + 1)
    );

    item = item.copyWith(
      death: death
    );
    await _ref.doc(item.id).update(item.toJson());
    return 1;
  }

  Future<int> deleteDeath(
    Member item,
  ) async {
    final oldDeathCause = item.death?.cause;
    if (oldDeathCause != null) {
      await _deathService.updateDeathCause(
        oldDeathCause.copyWith(quantity: oldDeathCause.quantity - 1)
      );
    }

    item = item.copyWith(
      death: null
    );
    await _ref.doc(item.id).update(item.toJson());
    return 1;
  }

  Future<int> updateDeath(
    Member item,
    Death death
  ) async {
    final oldDeathCause = item.death?.cause;
    if (oldDeathCause != null) {
      await _deathService.updateDeathCause(
        oldDeathCause.copyWith(quantity: oldDeathCause.quantity - 1)
      );
    }
    final deathCause = death.cause;
    await _deathService.updateDeathCause(
      deathCause.copyWith(quantity: deathCause.quantity + 1)
    );

    item = item.copyWith(
      death: death
    );
    await _ref.doc(item.id).update(item.toJson());
    return 1;
  }

  Future<int> addAchievement(
    Member item, 
    Achievement achievement,
  ) async {
    final type = achievement.type;
    await _achievementService.updateAchievementType(
      type.copyWith(quantity: type.quantity + 1)
    );
    item = item.copyWith(
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
      item = item.copyWith(
        achievements: newAchievements
      );
      await _ref.doc(item.id).update(item.toJson());
    }
    return 1;
  }

  Future<int> deleteAchievement(
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
    final type = achievement.type;
    await _achievementService.updateAchievementType(
      type.copyWith(quantity: type.quantity - 1)
    );
    final newAchievements = [...item.achievements..remove(updateAchievement)];
    newAchievements.sort((a, b) => a.time.compareTo(b.time));
    if (updateAchievement != null) {
      item = item.copyWith(
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

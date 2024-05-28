import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/services/member_services/member_firebase_service.dart';

class MemberRepository {
  late MemberRemoteService remoteService;

  MemberRepository() {
    remoteService = MemberRemoteService();
  }

  Future<List<Member>> getAllMembers()
  => remoteService.getAllMembers();

  Future<Member?> getMemberById(String id)
  => remoteService.getMemberById(id);

  Future<List<Member>?> getMembersByTreeCode(String code)
  => remoteService.getMembersByTreeCode(code);

  /// returns the id of the added member
  Future<String?> addMember(Member item)
  => remoteService.addMember(item);

  Future<int> updateMember(
    Member item, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateMember(item, updateData: updateData);

  Future<int> deleteMember(Member item)
  => remoteService.deleteMember(item);

  Future<int> addDeath(Member item, Death death)
  => remoteService.addDeath(item, death);

  Future<int> deleteDeath(Member item)
  => remoteService.deleteDeath(item);

  Future<int> updateDeath(Member item, Death death)
  => remoteService.updateDeath(item, death);

  Future<int> addAchievement(Member item, Achievement achievement)
  => remoteService.addAchievement(item, achievement);

  Future<int> updateAchievement(Member item, Achievement achievement)
  => remoteService.updateAchievement(item, achievement);

  Future<int> deleteAchievement(Member item, Achievement achievement)
  => remoteService.deleteAchievement(item, achievement);
}

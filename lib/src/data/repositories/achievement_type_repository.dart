import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/services/achievement_type_services/achievement_type_firebase_service.dart';

class AchievementTypeRepository {
  late AchievementTypeRemoteService remoteService;

  AchievementTypeRepository() {
    remoteService = AchievementTypeRemoteService();
  }

  Future<List<AchievementType>> getAllAchievementTypes()
  => remoteService.getAllAchievementTypes();

  Future<AchievementType?> getAchievementTypeById(String typeId)
  => remoteService.getAchievementTypeById(typeId);

  Future<bool> addAchievementType(AchievementType type)
  => remoteService.addAchievementType(type);

  Future<int> updateAchievementType(
    AchievementType type, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateAchievementType(type, updateData: updateData);

  Future<int> deleteAchievementType(AchievementType type)
  => remoteService.deleteAchievementType(type);
}

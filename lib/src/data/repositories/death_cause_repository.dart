import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/services/death_cause_services/death_cause_firebase_service.dart';

class DeathCauseRepository {
  late DeathCauseRemoteService remoteService;

  DeathCauseRepository() {
    remoteService = DeathCauseRemoteService();
  }

  Future<List<CauseOfDeath>> getAllDeathCauses()
  => remoteService.getAllDeathCauses();

  Future<CauseOfDeath?> getDeathCauseById(String causeId)
  => remoteService.getDeathCauseById(causeId);

  Future<bool> addDeathCause(CauseOfDeath cause)
  => remoteService.addDeathCause(cause);

  Future<int> updateDeathCause(
    CauseOfDeath cause, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateDeathCause(cause, updateData: updateData);

  Future<int> deleteDeathCause(CauseOfDeath cause)
  => remoteService.deleteDeathCause(cause);
}

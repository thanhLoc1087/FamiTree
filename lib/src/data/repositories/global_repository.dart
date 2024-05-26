import 'dart:async';

import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/services/global/global_remote_service.dart';

class GlobalRepository {
  late GlobalRemoteService remoteService;

  GlobalRepository() {
    remoteService = GlobalRemoteService();
  }

  Future<StreamSubscription?> listenPlaces({
    required Function(List<Place>)? onListen,
  }) {
    return remoteService.listenPlaces(
      onListen: onListen
    );
  }

  Future<StreamSubscription?> listenJobs({
    required Function(List<Job>)? onListen,
  }) {
    return remoteService.listenJobs(
      onListen: onListen
    );
  }

  Future<StreamSubscription?> listenRelationshipTypes({
    required Function(List<RelationshipType>)? onListen,
  }) {
    return remoteService.listenRelationshipTypes(
      onListen: onListen
    );
  }

  Future<StreamSubscription?> listenAchievementTypes({
    required Function(List<AchievementType>)? onListen,
  }) {
    return remoteService.listenAchievementTypes(
      onListen: onListen
    );
  }

  Future<StreamSubscription?> listenDeathCauses({
    required Function(List<CauseOfDeath>)? onListen,
  }) {
    return remoteService.listenDeathCauses(
      onListen: onListen
    );
  }

  Future<StreamSubscription?> listenMyMembers({
    required Function(List<Member>)? onListen,
    required String? treeCode,
  }) {
    return remoteService.listenMyMembers(
      onListen: onListen,
      treeCode: treeCode,
    );
  }
}

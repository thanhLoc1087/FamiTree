
import 'dart:async';

import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/data/repositories/global_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class GlobalData {
  static final GlobalData _instance = GlobalData._internal();

  factory GlobalData() => _instance;

  GlobalData._internal() {
    _repository = GlobalRepository();

    streamAchievementTypes = BehaviorSubject();
    streamRelationshipTypes = BehaviorSubject();
    streamPlaces = BehaviorSubject();
    streamJobs = BehaviorSubject();
    streamDeathCauses = BehaviorSubject();
  }

  void listenAll() {
    debugPrint("ADFDAF");
    _listenStreams();
  }

  void disposeAll() {
    _cancelSubscription(fbAchievementTypes);
    _cancelSubscription(fbRelationshipTypes);
    _cancelSubscription(fbPlaces);
    _cancelSubscription(fbJobs);
    _cancelSubscription(fbDeathCauses);

    streamAchievementTypes.add([]);
    streamRelationshipTypes.add([]);
    streamPlaces.add([]);
    streamJobs.add([]);
    streamDeathCauses.add([]);
  }

  late GlobalRepository _repository;

  /// Behavior Subjects
  late BehaviorSubject<List<AchievementType>> streamAchievementTypes;
  late BehaviorSubject<List<RelationshipType>> streamRelationshipTypes;
  late BehaviorSubject<List<Place>> streamPlaces;
  late BehaviorSubject<List<Job>> streamJobs;
  late BehaviorSubject<List<CauseOfDeath>> streamDeathCauses;

  /// Firebase Stream Subscription
  StreamSubscription? fbAchievementTypes;
  StreamSubscription? fbRelationshipTypes;
  StreamSubscription? fbPlaces;
  StreamSubscription? fbJobs;
  StreamSubscription? fbDeathCauses;

  /// Getter
  bool get _isLoggedIn => MyUser.currentUser != null;

  List<AchievementType> get achievementTypes => streamAchievementTypes.valueOrNull ?? [];
  List<RelationshipType> get relationshipTypes => streamRelationshipTypes.valueOrNull ?? [];
  List<Place> get places => streamPlaces.valueOrNull ?? [];
  List<Job> get jobs => streamJobs.valueOrNull ?? [];
  List<CauseOfDeath> get deathCauses => streamDeathCauses.valueOrNull ?? [];


  void _listenStreams() async {
    if (!_isLoggedIn) {
      return;
    }
    
    await _cancelSubscription(fbPlaces);
    fbPlaces = await _repository.listenPlaces(
      onListen: (value) {
        streamPlaces.add(value);
      },
    );

    await _cancelSubscription(fbJobs);
    fbJobs = await _repository.listenJobs(
      onListen: (value) {
        streamJobs.add(value);
      },
    );

    await _cancelSubscription(fbDeathCauses);
    fbDeathCauses = await _repository.listenDeathCauses(
      onListen: (value) {
        streamDeathCauses.add(value);
      },
    );

    await _cancelSubscription(fbRelationshipTypes);
    fbRelationshipTypes = await _repository.listenRelationshipTypes(
      onListen: (value) {
        streamRelationshipTypes.add(value);
      },
    );

    await _cancelSubscription(fbAchievementTypes);
    fbAchievementTypes = await _repository.listenAchievementTypes(
      onListen: (value) {
        streamAchievementTypes.add(value);
      },
    );
  }

  _cancelSubscription(StreamSubscription? subs) async {
    await subs?.cancel();
    subs = null;
  }

  _cancelSubject(BehaviorSubject? subject) {
    subject?.close();
    subject = null;
  }
}



import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/common_utils.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/models/relationship_type.dart';

class GlobalRemoteService {
  Future<StreamSubscription?> listenPlaces({
    Function(
      List<Place>,
    )? onListen,
  }) async {
    final placesQuery = FirebaseFirestore.instance
        .collection(AppCollections.places)
        .snapshots();

    final subs = placesQuery.listen((event) async {
      final places = event.docs
          .map((e) => Place.fromJson(id: e.id, json: e.data()))
          .toList();
      places.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
      if (onListen != null) {
        onListen(places);
      }
    });
    return subs;
  }

  Future<StreamSubscription?> listenJobs({
    Function(
      List<Job>,
    )? onListen,
  }) async {
    final jobsQuery = FirebaseFirestore.instance
        .collection(AppCollections.jobs)
        .snapshots();

    final subs = jobsQuery.listen((event) async {
      final jobs = event.docs
          .map((e) => Job.fromJson(id: e.id, json: e.data()))
          .toList();
      jobs.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
      if (onListen != null) {
        onListen(jobs);
      }
    });
    return subs;
  }

  Future<StreamSubscription?> listenAchievementTypes({
    Function(
      List<AchievementType>,
    )? onListen,
  }) async {
    final typesQuery = FirebaseFirestore.instance
        .collection(AppCollections.achievementTypes)
        .snapshots();

    final subs = typesQuery.listen((event) async {
      final types = event.docs
          .map((e) => AchievementType.fromJson(id: e.id, json: e.data()))
          .toList();
      types.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
      if (onListen != null) {
        onListen(types);
      }
    });
    return subs;
  }

  Future<StreamSubscription?> listenRelationshipTypes({
    Function(
      List<RelationshipType>,
    )? onListen,
  }) async {
    final typesQuery = FirebaseFirestore.instance
        .collection(AppCollections.relationshipTypes)
        .snapshots();

    final subs = typesQuery.listen((event) async {
      final types = event.docs
          .map((e) => RelationshipType.fromJson(id: e.id, json: e.data()))
          .toList();
      types.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
      if (onListen != null) {
        onListen(types);
      }
    });
    return subs;
  }

  Future<StreamSubscription?> listenDeathCauses({
    Function(
      List<CauseOfDeath>,
    )? onListen,
  }) async {
    final causesQuery = FirebaseFirestore.instance
        .collection(AppCollections.deathCauses)
        .snapshots();

    final subs = causesQuery.listen((event) async {
      final causes = event.docs
          .map((e) => CauseOfDeath.fromJson(id: e.id, json: e.data()))
          .toList();
      causes.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
      if (onListen != null) {
        onListen(causes);
      }
    });
    return subs;
  }
}



import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/common_utils.dart';
import 'package:famitree/src/data/models/place.dart';

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
          .map((e) => Place.fromJSon(id: e.id, json: e.data()))
          .toList();
      places.sort(
        (a, b) => removeVietnameseTones(a.name.toLowerCase().trim())
            .compareTo(removeVietnameseTones(b.name.toLowerCase().trim())),
      );
    });
    return subs;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/data/models/place.dart';

class PlaceRemoteService {
  final _placeRef =
      FirebaseFirestore.instance.collection(AppCollections.places);

  Future<List<Place>> getAllPlaces() async {
    final result = await _placeRef
        .where("status", isEqualTo: 1)
        .get();

    List<Place> places = result.docs
        .map((e) => Place.fromJSon(id: e.id, json: e.data()))
        .toList();

    return places;
  }

  Future<Place?> getPlaceById(String placeId) async {
    final data = await _placeRef
        .doc(placeId)
        .get();
    if (data.exists) {
      return Place.fromJSon(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addPlace(
    // 1 - tạo thành công
    // 0 - that bai
    Place place
  ) async {
    try {
      await _placeRef.add(place.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<int> updatePlace(
    Place place, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _placeRef.doc(place.id).update(updateData);
    } else {
      await _placeRef.doc(_placeRef.id).update(place.toJson());
    }
    return 1;
  }

  Future<int> deletePlace(
    Place place
  ) async {
    final res = await updatePlace(
      place,
      updateData: {"status": 0});
    return res;
  }
}

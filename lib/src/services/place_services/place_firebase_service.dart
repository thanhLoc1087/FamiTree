import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famitree/src/core/constants/collections.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/pair.dart';
import 'package:famitree/src/data/models/place.dart';

class PlaceRemoteService {
  final _placeRef =
      FirebaseFirestore.instance.collection(AppCollections.places);

  Future<List<Place>> getAllPlaces() async {
    final result = await _placeRef
        .where("deleted", isEqualTo: false)
        .get();

    List<Place> places = result.docs
        .map((e) => Place.fromJson(id: e.id, json: e.data()))
        .toList();

    return places;
  }

  Future<Place?> getPlaceById(String placeId) async {
    final data = await _placeRef
        .doc(placeId)
        .get();
    if (data.exists) {
      return Place.fromJson(id: data.id, json: data.data()!);
    }
    return null;
  }

  Future<bool> addPlace(
    // 1 - tạo thành công
    // 0 - that bai
    Place place
  ) async {
    try {
      final countExistedName =
          await countExistingNames(place.name.trim());
      if (countExistedName.a + countExistedName.b > 0) {
        return false;
      }
      await _placeRef.add(place.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
  
  Future<Pair> countExistingNames(String placeName) async {
    // xóa lẫn thường, có trùng tên là lấy
    // Trả về pair, số name đã xóa, số name còn sống
    final result = await _placeRef
        .where("name", isEqualTo: placeName)
        .get();
    int countDeleted = 0;
    int countUndeleted = 0;
    for (var doc in result.docs) {
      if (cvToBool(doc['deleted'], false)) {
        countDeleted++;
      } else {
        countUndeleted++;
      }
    }
    return Pair(countDeleted, countUndeleted);
  }

  Future<int> updatePlace(
    Place place, {
    Map<String, dynamic>? updateData,
  }) async {
    if (updateData != null) {
      await _placeRef.doc(place.id).update(updateData);
    } else {
      await _placeRef.doc(place.id).update(place.toJson());
    }
    return 1;
  }

  Future<int> deletePlace(
    Place place
  ) async {
    final res = await updatePlace(
      place,
      updateData: {"deleted": true});
    return res;
  }
}

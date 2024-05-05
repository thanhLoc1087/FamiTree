import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/services/place_services/place_firebase_service.dart';

class PlaceRepository {
  late PlaceRemoteService remoteService;

  PlaceRepository() {
    remoteService = PlaceRemoteService();
  }

  Future<List<Place>> getAllPlaces()
  => remoteService.getAllPlaces();

  Future<Place?> getPlaceById(String placeId)
  => remoteService.getPlaceById(placeId);

  Future<bool> addPlace(Place place)
  => remoteService.addPlace(place);

  Future<int> updatePlace(
    Place place, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updatePlace(place, updateData: updateData);

  Future<int> deletePlace(Place place)
  => remoteService.deletePlace(place);
}

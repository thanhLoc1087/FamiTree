import 'dart:async';

import 'package:famitree/src/data/models/place.dart';
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
}

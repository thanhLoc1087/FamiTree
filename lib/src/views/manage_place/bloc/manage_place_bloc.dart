
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/repositories/place_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_place_event.dart';
part 'manage_place_state.dart';

class ManagePlaceBloc extends Bloc<ManagePlaceEvent, ManagePlaceState> {
  final PlaceRepository placeRepository;
  StreamSubscription<List<Place>>? allPlaceSub;
  
  ManagePlaceBloc(this.placeRepository) : super(const ManagePlaceState()) {
    on<LoadDataPlaceEvent>(_loadData);
    on<AddPlaceEvent>(_addPlace);
    on<UpdatePlaceEvent>(_updatePlace);
    on<DeletePlaceEvent>(_deletePlace);
    on<RestorePlaceEvent>(_restorePlace);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allPlaceSub?.cancel();
    allPlaceSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    allPlaceSub = GlobalData().streamPlaces.listen((event) {
      debugPrint("Global places: $event");
      List<Place> places = event;
      add(LoadDataPlaceEvent(places));
    });
  }

  FutureOr<void> _loadData(LoadDataPlaceEvent event, Emitter<ManagePlaceState> emit) {
    emit(state.copyWith(
      places: event.places
    ));
  }

  Future<FutureOr<void>> _addPlace(AddPlaceEvent event, Emitter<ManagePlaceState> emit) async {
    DialogUtils.showLoading();

    final isSuccess = await placeRepository.addPlace(
      event.place,
    );

    if (isSuccess) {
      Toasty.show("Thêm dịch vụ thành công!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateManagePlaceState.fromManagePlaceState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateManagePlaceState.fromManagePlaceState(
        state,
        errorMessage: "Thêm dịch vụ thất bại!\nTên hoặc mã vạch đã tồn tại",
      ));
    }
  }

  Future<FutureOr<void>> _updatePlace(UpdatePlaceEvent event, Emitter<ManagePlaceState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await placeRepository.updatePlace(
      event.place,
    );

    if (numSuccess > 0) {
      Toasty.show("Restore place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _deletePlace(DeletePlaceEvent event, Emitter<ManagePlaceState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await placeRepository.deletePlace(
      event.place,
    );

    if (numSuccess > 0) {
      Toasty.show("Delete place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _restorePlace(RestorePlaceEvent event, Emitter<ManagePlaceState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await placeRepository.updatePlace(
      event.place.copyWith(deleted: false),
    );

    if (numSuccess > 0) {
      Toasty.show("Restore place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }
}

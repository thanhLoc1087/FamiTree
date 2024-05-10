
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/repositories/achievement_type_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_achievement_type_event.dart';
part 'manage_achievement_type_state.dart';

class ManageAchievementTypeBloc extends Bloc<ManageAchievementTypeEvent, ManageAchievementTypeState> {
  final AchievementTypeRepository repository;
  StreamSubscription<List<AchievementType>>? allAchievementTypeSub;
  
  ManageAchievementTypeBloc(this.repository) : super(const ManageAchievementTypeState()) {
    on<LoadDataAchievementTypeEvent>(_loadData);
    on<AddAchievementTypeEvent>(_add);
    on<UpdateAchievementTypeEvent>(_update);
    on<DeleteAchievementTypeEvent>(_delete);
    on<RestoreAchievementTypeEvent>(_restore);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allAchievementTypeSub?.cancel();
    allAchievementTypeSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    allAchievementTypeSub = GlobalData().streamAchievementTypes.listen((event) {
      debugPrint("Global items: $event");
      List<AchievementType> items = event;
      add(LoadDataAchievementTypeEvent(items));
    });
  }

  FutureOr<void> _loadData(LoadDataAchievementTypeEvent event, Emitter<ManageAchievementTypeState> emit) {
    emit(state.copyWith(
      items: event.items
    ));
  }

  Future<FutureOr<void>> _add(AddAchievementTypeEvent event, Emitter<ManageAchievementTypeState> emit) async {
    DialogUtils.showLoading();

    final isSuccess = await repository.addAchievementType(
      event.item,
    );

    if (isSuccess) {
      Toasty.show("Thêm dịch vụ thành công!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateManageAchievementTypeState.fromManageAchievementTypeState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateManageAchievementTypeState.fromManageAchievementTypeState(
        state,
        errorMessage: "Thêm dịch vụ thất bại!\nTên hoặc mã vạch đã tồn tại",
      ));
    }
  }

  Future<FutureOr<void>> _update(UpdateAchievementTypeEvent event, Emitter<ManageAchievementTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateAchievementType(
      event.item,
    );

    if (numSuccess > 0) {
      Toasty.show("Restore place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _delete(DeleteAchievementTypeEvent event, Emitter<ManageAchievementTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.deleteAchievementType(
      event.item,
    );

    if (numSuccess > 0) {
      Toasty.show("Delete place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _restore(RestoreAchievementTypeEvent event, Emitter<ManageAchievementTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateAchievementType(
      event.item.copyWith(deleted: false),
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

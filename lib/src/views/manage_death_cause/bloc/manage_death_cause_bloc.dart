
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/repositories/death_cause_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_death_cause_event.dart';
part 'manage_death_cause_state.dart';

class ManageDeathCauseBloc extends Bloc<ManageDeathCauseEvent, ManageDeathCauseState> {
  final DeathCauseRepository repository;
  StreamSubscription<List<CauseOfDeath>>? allDeathCauseSub;
  
  ManageDeathCauseBloc(this.repository) : super(const ManageDeathCauseState()) {
    on<LoadDataDeathCauseEvent>(_loadData);
    on<AddDeathCauseEvent>(_add);
    on<UpdateDeathCauseEvent>(_update);
    on<DeleteDeathCauseEvent>(_delete);
    on<RestoreDeathCauseEvent>(_restore);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allDeathCauseSub?.cancel();
    allDeathCauseSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    allDeathCauseSub = GlobalData().streamDeathCauses.listen((event) {
      debugPrint("Global items: $event");
      List<CauseOfDeath> items = event;
      add(LoadDataDeathCauseEvent(items));
    });
  }

  FutureOr<void> _loadData(LoadDataDeathCauseEvent event, Emitter<ManageDeathCauseState> emit) {
    emit(state.copyWith(
      items: event.items
    ));
  }

  Future<FutureOr<void>> _add(AddDeathCauseEvent event, Emitter<ManageDeathCauseState> emit) async {
    DialogUtils.showLoading();

    final isSuccess = await repository.addDeathCause(
      event.item,
    );

    if (isSuccess) {
      Toasty.show("Thêm dịch vụ thành công!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateManageDeathCauseState.fromManageDeathCauseState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateManageDeathCauseState.fromManageDeathCauseState(
        state,
        errorMessage: "Thêm dịch vụ thất bại!\nTên hoặc mã vạch đã tồn tại",
      ));
    }
  }

  Future<FutureOr<void>> _update(UpdateDeathCauseEvent event, Emitter<ManageDeathCauseState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateDeathCause(
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

  Future<FutureOr<void>> _delete(DeleteDeathCauseEvent event, Emitter<ManageDeathCauseState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.deleteDeathCause(
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

  Future<FutureOr<void>> _restore(RestoreDeathCauseEvent event, Emitter<ManageDeathCauseState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateDeathCause(
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

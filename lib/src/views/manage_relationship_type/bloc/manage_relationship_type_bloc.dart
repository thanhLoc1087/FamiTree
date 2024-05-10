
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/data/repositories/relationship_type_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_relationship_type_event.dart';
part 'manage_relationship_type_state.dart';

class ManageRelationshipTypeBloc extends Bloc<ManageRelationshipTypeEvent, ManageRelationshipTypeState> {
  final RelationshipTypeRepository repository;
  StreamSubscription<List<RelationshipType>>? allRelationshipTypeSub;
  
  ManageRelationshipTypeBloc(this.repository) : super(const ManageRelationshipTypeState()) {
    on<LoadDataRelationshipTypeEvent>(_loadData);
    on<AddRelationshipTypeEvent>(_add);
    on<UpdateRelationshipTypeEvent>(_update);
    on<DeleteRelationshipTypeEvent>(_delete);
    on<RestoreRelationshipTypeEvent>(_restore);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allRelationshipTypeSub?.cancel();
    allRelationshipTypeSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    allRelationshipTypeSub = GlobalData().streamRelationshipTypes.listen((event) {
      debugPrint("Global items: $event");
      List<RelationshipType> items = event;
      add(LoadDataRelationshipTypeEvent(items));
    });
  }

  FutureOr<void> _loadData(LoadDataRelationshipTypeEvent event, Emitter<ManageRelationshipTypeState> emit) {
    emit(state.copyWith(
      items: event.items
    ));
  }

  Future<FutureOr<void>> _add(AddRelationshipTypeEvent event, Emitter<ManageRelationshipTypeState> emit) async {
    DialogUtils.showLoading();

    final isSuccess = await repository.addRelationshipType(
      event.item,
    );

    if (isSuccess) {
      Toasty.show("Thêm dịch vụ thành công!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateManageRelationshipTypeState.fromManageRelationshipTypeState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateManageRelationshipTypeState.fromManageRelationshipTypeState(
        state,
        errorMessage: "Thêm dịch vụ thất bại!\nTên hoặc mã vạch đã tồn tại",
      ));
    }
  }

  Future<FutureOr<void>> _update(UpdateRelationshipTypeEvent event, Emitter<ManageRelationshipTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateRelationshipType(
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

  Future<FutureOr<void>> _delete(DeleteRelationshipTypeEvent event, Emitter<ManageRelationshipTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.deleteRelationshipType(
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

  Future<FutureOr<void>> _restore(RestoreRelationshipTypeEvent event, Emitter<ManageRelationshipTypeState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await repository.updateRelationshipType(
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

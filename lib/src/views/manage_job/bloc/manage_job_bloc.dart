
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/repositories/job_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_job_event.dart';
part 'manage_job_state.dart';

class ManageJobBloc extends Bloc<ManageJobEvent, ManageJobState> {
  final JobRepository jobRepository;
  StreamSubscription<List<Job>>? allJobSub;
  
  ManageJobBloc(this.jobRepository) : super(const ManageJobState()) {
    on<LoadDataJobEvent>(_loadData);
    on<AddJobEvent>(_addJob);
    on<UpdateJobEvent>(_updateJob);
    on<DeleteJobEvent>(_deleteJob);
    on<RestoreJobEvent>(_restoreJob);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allJobSub?.cancel();
    allJobSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    allJobSub = GlobalData().streamJobs.listen((event) {
      debugPrint("Global jobs: $event");
      List<Job> jobs = event;
      add(LoadDataJobEvent(jobs));
    });
  }

  FutureOr<void> _loadData(LoadDataJobEvent event, Emitter<ManageJobState> emit) {
    emit(state.copyWith(
      jobs: event.jobs
    ));
  }

  Future<FutureOr<void>> _addJob(AddJobEvent event, Emitter<ManageJobState> emit) async {
    DialogUtils.showLoading();

    final isSuccess = await jobRepository.addJob(
      event.job,
    );

    if (isSuccess) {
      Toasty.show("Thêm dịch vụ thành công!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateManageJobState.fromManageJobState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateManageJobState.fromManageJobState(
        state,
        errorMessage: "Thêm dịch vụ thất bại!\nTên hoặc mã vạch đã tồn tại",
      ));
    }
  }

  Future<FutureOr<void>> _updateJob(UpdateJobEvent event, Emitter<ManageJobState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await jobRepository.updateJob(
      event.job,
    );

    if (numSuccess > 0) {
      Toasty.show("Restore place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _deleteJob(DeleteJobEvent event, Emitter<ManageJobState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await jobRepository.deleteJob(
      event.job,
    );

    if (numSuccess > 0) {
      Toasty.show("Delete place successfully!");
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _restoreJob(RestoreJobEvent event, Emitter<ManageJobState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await jobRepository.updateJob(
      event.job.copyWith(deleted: false),
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

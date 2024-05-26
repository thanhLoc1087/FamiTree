
import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/data/repositories/member_repository.dart';
import 'package:famitree/src/data/repositories/tree_repoditory.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final TreeRepository _treeRepository; 
  final MemberRepository _memberRepository;
  StreamSubscription<List<FamilyTree>>? allTreeSub;
  StreamSubscription<List<Place>>? allPlacesSub;
  StreamSubscription<List<Job>>? allJobsSub;
  StreamSubscription<List<AchievementType>>? allAchievementTypesSub;
  StreamSubscription<List<RelationshipType>>? allRelationshipTypesSub;
  StreamSubscription<List<CauseOfDeath>>? allDeathCausesSub;
  // StreamSubscription<List<Member>>? allMyMembersSub;
  
  StreamSubscription<
    (
      // List<FamilyTree>,
      List<Place>,
      List<Job>,
      List<AchievementType>,
      List<RelationshipType>,
      List<CauseOfDeath>,
      // List<Member>,
    )>? mergeStreamSub;
  
  HomePageBloc(this._treeRepository, this._memberRepository) : super(const HomePageState()) {
    on<LoadDataHomeEvent>(_loadData, transformer: droppable());
    on<AddTreeHomeEvent>(_add);
    on<UpdateHomeEvent>(_update);
    on<DeleteTreeHomeEvent>(_delete);
    on<RestoreTreeHomeEvent>(_restore);
    on<AddMemberEvent>(_addMember);
    on<AddAchievementEvent>(_addAchievement);
    on<AddDeathEvent>(_addDeath);
    _streamListen();
  }

  @override
  Future<void> close() async {
    _cancelAllSubs();
    super.close();
  }
  
  _cancelAllSubs() {
    allPlacesSub?.cancel();
    allPlacesSub = null;
    allAchievementTypesSub?.cancel();
    allAchievementTypesSub = null;
    allRelationshipTypesSub?.cancel();
    allRelationshipTypesSub = null;
    allJobsSub?.cancel();
    allJobsSub = null;
    allDeathCausesSub?.cancel();
    allDeathCausesSub = null;
    mergeStreamSub?.cancel();
    mergeStreamSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    debugPrint("Listening");

    mergeStreamSub = Rx.combineLatest5(
        GlobalData().streamPlaces,
        GlobalData().streamJobs,
        GlobalData().streamAchievementTypes,
        GlobalData().streamRelationshipTypes,
        GlobalData().streamDeathCauses,
        (places, jobs, achievementTypes, relationshipTypes, deathCauses) {
      return (places, jobs, achievementTypes, relationshipTypes, deathCauses);
    }).listen((event) {
      List<Place> places = event.$1;
      List<Job> jobs = event.$2;
      List<AchievementType> achievementTypes = event.$3;
      List<RelationshipType> relationshipTypes = event.$4;
      List<CauseOfDeath> deathCauses = event.$5;

      add(LoadDataHomeEvent(
        places: places,
        jobs: jobs,
        achievementTypes: achievementTypes,
        relationshipTypes: relationshipTypes,
        deathCauses: deathCauses,
      ));
    });
  }

  Future<void> _loadData(LoadDataHomeEvent event, Emitter<HomePageState> emit) async {
    final members = await _memberRepository.getMembersByTreeCode(
      CurrentUser().user.treeCode ?? ''
    );
    final mystate = state.copyWith(
      places: GlobalData().places,
      jobs: GlobalData().jobs,
      achievementTypes: GlobalData().achievementTypes,
      relationshipTypes: GlobalData().relationshipTypes,
      deathCauses: GlobalData().deathCauses,
      members: members,
    );
    emit(mystate);
  }

  Future<FutureOr<void>> _add(AddTreeHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    bool success = await _treeRepository.addTree(
      CurrentUser().user,
      event.item,
      event.firstMember,
    );

    CurrentUser().user = CurrentUser().user.copyWith(
      treeCode: event.item.treeCode,
      oldCode: CurrentUser().user.treeCode
    );

    if (success) {
      DialogUtils.hideLoading();
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to create new tree!\nTree code already exists",
      ));
    }
  }

  Future<FutureOr<void>> _addMember(AddMemberEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    String? memberId = await _memberRepository.addMember(
      event.member,
    );

    if (memberId != null) {
      Toasty.show("Add new member successfully!");
      DialogUtils.hideLoading();
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add new member!",
      ));
    }
  }

  Future<FutureOr<void>> _update(UpdateHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await _treeRepository.updateTree(
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

  Future<FutureOr<void>> _delete(DeleteTreeHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await _treeRepository.deleteTree(
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

  Future<FutureOr<void>> _restore(RestoreTreeHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await _treeRepository.updateTree(
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

  Future<void> _addAchievement(AddAchievementEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    final success = await _memberRepository.addAchievement(
      event.member,
      event.achievement,
    );

    if (success == 1) {
      DialogUtils.hideLoading();
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member achievement!",
      ));
    }
  }

  Future<void> _addDeath(AddDeathEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    final success = await _memberRepository.addDeath(
      event.member,
      event.death,
    );

    if (success == 1) {
      DialogUtils.hideLoading();
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member death!",
      ));
    }
  }
}


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
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/data/repositories/member_repository.dart';
import 'package:famitree/src/data/repositories/tree_repository.dart';
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
  StreamSubscription<List<Member>>? allMyMembersSub;
  
  StreamSubscription<
    (
      // List<FamilyTree>,
      List<Place>,
      List<Job>,
      List<AchievementType>,
      List<RelationshipType>,
      List<CauseOfDeath>,
      List<Member>,
    )>? mergeStreamSub;
  
  HomePageBloc(this._treeRepository, this._memberRepository) : super(const HomePageState()) {
    on<InitHomeEvent>(_onInit);
    on<LoadDataHomeEvent>(_loadData, transformer: droppable());
    on<AddTreeHomeEvent>(_add);
    on<SelectMemberHomeEvent>(_selectMember);
    on<UpdateHomeEvent>(_update);
    on<DeleteTreeHomeEvent>(_delete);
    on<RestoreTreeHomeEvent>(_restore);
    on<AddMemberEvent>(_addMember);
    on<UpdateMemberEvent>(_updateMember);
    on<AddAchievementEvent>(_addAchievement);
    on<UpdateAchievementEvent>(_updateAchievement);
    on<DeleteAchievementEvent>(_deleteAchievement);
    on<AddDeathEvent>(_addDeath);
    on<DeleteDeathEvent>(_deleteDeath);
    on<UpdateDeathEvent>(_updateDeath);
    on<JoinTreeHomeEvent>(_joinTree);
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
    allMyMembersSub?.cancel();
    allMyMembersSub = null;
    mergeStreamSub?.cancel();
    mergeStreamSub = null;
  }

  _streamListen() {
    /// Cancel all subs before listen new event
    _cancelAllSubs();

    debugPrint("Listening");

    mergeStreamSub = Rx.combineLatest6(
        GlobalData().streamPlaces,
        GlobalData().streamJobs,
        GlobalData().streamAchievementTypes,
        GlobalData().streamRelationshipTypes,
        GlobalData().streamDeathCauses,
        GlobalData().streamMyMembers,
        (places, jobs, achievementTypes, relationshipTypes, deathCauses, members) {
      return (places, jobs, achievementTypes, relationshipTypes, deathCauses, members);
    }).listen((event) async {
      List<Place> places = event.$1;
      List<Job> jobs = event.$2;
      List<AchievementType> achievementTypes = event.$3;
      List<RelationshipType> relationshipTypes = event.$4;
      List<CauseOfDeath> deathCauses = event.$5;
      List<Member> members = event.$6;

      FamilyTree? tree;
      if (CurrentUser().user.treeCode != null) {
        tree = await _treeRepository.getTreeByCode(CurrentUser().user.treeCode!);
      }
    
      add(LoadDataHomeEvent(
        places: places,
        jobs: jobs,
        achievementTypes: achievementTypes,
        relationshipTypes: relationshipTypes,
        deathCauses: deathCauses,
        members: members,
        tree: tree,
      ));
    });
  }

  Future<void> _onInit(InitHomeEvent event, Emitter<HomePageState> emit) async {
    _streamListen();
  }
  Future<void> _loadData(LoadDataHomeEvent event, Emitter<HomePageState> emit) async {
    // final members = await _memberRepository.getMembersByTreeCode(
    //   CurrentUser().user.treeCode ?? ''
    // );

    final mystate = state.copyWith(
      places: GlobalData().places,
      jobs: GlobalData().jobs,
      achievementTypes: GlobalData().achievementTypes,
      relationshipTypes: GlobalData().relationshipTypes,
      deathCauses: GlobalData().deathCauses,
      members: GlobalData().myMembers,
      myTree: event.tree,
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

  
  Future<void> _updateMember(UpdateMemberEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await _memberRepository.updateMember(
      event.member,
    );


    if (numSuccess > 0) {
      if (event.member.id == state.selectedMember?.id) {
        emit(state.copyWith(selectedMember: event.member));
      }
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
      DialogUtils.hideLoading();
    } else {
      DialogUtils.hideLoading();
      Toasty.show("Failed!", type: ToastType.error);
    }
  }

  Future<FutureOr<void>> _update(UpdateHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();

    final numSuccess = await _treeRepository.updateTree(
      event.item,
    );

    if (numSuccess > 0) {
      Toasty.show("Update Tree successfully!");
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
      Toasty.show("Delete Tree successfully!");
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
      Toasty.show("Restore Tree successfully!");
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
      if (event.member.id == state.selectedMember?.id) {
        emit(state.copyWith(selectedMember: event.member));
      }
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member achievement!",
      ));
    }
  }

  Future<void> _updateAchievement(UpdateAchievementEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    final success = await _memberRepository.updateAchievement(
      event.member,
      event.achievement,
    );

    if (success == 1) {
      DialogUtils.hideLoading();
      if (event.member.id == state.selectedMember?.id) {
        emit(state.copyWith(selectedMember: event.member));
      }
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member achievement!",
      ));
    }
  }

  Future<void> _deleteAchievement(DeleteAchievementEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    final success = await _memberRepository.deleteAchievement(
      event.member,
      event.achievement,
    );

    if (success == 1) {
      DialogUtils.hideLoading();
      if (event.member.id == state.selectedMember?.id) {
        emit(state.copyWith(selectedMember: event.member));
      }
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
      if (event.member.id == state.selectedMember?.id) {
        emit(state.copyWith(selectedMember: event.member));
      }
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member death!",
      ));
    }
  }

  Future<FutureOr<void>> _joinTree(JoinTreeHomeEvent event, Emitter<HomePageState> emit) async {
    DialogUtils.showLoading();
    final success = await MyUser.updateTreeCode(
      CurrentUser().user,
      event.code
    );


    if (success == 1) {
      DialogUtils.hideLoading();
      emit(CompleteUpdateHomePageState.fromHomePageState(state));
      add(const InitHomeEvent());
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add tree!",
      ));
    }
  }

  FutureOr<void> _selectMember(SelectMemberHomeEvent event, Emitter<HomePageState> emit) {
    emit(
      state.copyWith(
        selectedMember: event.member
      )
    );
  }

  Future<FutureOr<void>> _deleteDeath(DeleteDeathEvent event, Emitter<HomePageState> emit) async {
    final success = await _memberRepository.deleteDeath(event.member);

    if (success == 1) {
      DialogUtils.hideLoading();
      final newState = state.copyWith(
        selectedMember: event.member..deleteDeath()
      );
      emit(CompleteUpdateHomePageState.fromHomePageState(newState));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member death!",
      ));
    }
  }

  Future<FutureOr<void>> _updateDeath(UpdateDeathEvent event, Emitter<HomePageState> emit) async {
    final success = await _memberRepository.updateDeath(event.member, event.death);

    if (success == 1) {
      DialogUtils.hideLoading();
      final newState = state.copyWith(
        selectedMember: event.member.copyWith(death: event.death)
      );
      emit(CompleteUpdateHomePageState.fromHomePageState(newState));
    } else {
      DialogUtils.hideLoading();
      emit(ErrorUpdateHomePageState.fromHomePageState(
        state,
        errorMessage: "Failed to add member death!",
      ));
    }
  }
}

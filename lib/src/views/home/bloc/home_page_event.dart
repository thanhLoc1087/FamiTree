part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class InitHomeEvent extends HomePageEvent {

  const InitHomeEvent();
}

class LoadDataHomeEvent extends HomePageEvent {
  final List<Place>? places;
  final List<Job>? jobs;
  final List<AchievementType>? achievementTypes;
  final List<RelationshipType>? relationshipTypes;
  final List<CauseOfDeath>? deathCauses;
  final List<Member>? members;
  final FamilyTree? tree;

  const LoadDataHomeEvent({
    this.places,
    this.jobs,
    this.achievementTypes,
    this.relationshipTypes,
    this.deathCauses,
    this.members,
    this.tree,
  });
}

class AddTreeHomeEvent extends HomePageEvent {
  final FamilyTree item;
  final Member firstMember;

  const AddTreeHomeEvent(this.item, this.firstMember);
}

class SelectMemberHomeEvent extends HomePageEvent {
  final Member member;

  const SelectMemberHomeEvent(this.member);
}

class AddMemberEvent extends HomePageEvent {
  final Member member;

  const AddMemberEvent(this.member);
}

class UpdateMemberEvent extends HomePageEvent {
  final Member member;

  const UpdateMemberEvent(this.member);
}

class AddAchievementEvent extends HomePageEvent {
  Member member;
  final Achievement achievement;

  AddAchievementEvent(this.member, this.achievement);
}

class UpdateAchievementEvent extends HomePageEvent {
  Member member;
  final Achievement achievement;

  UpdateAchievementEvent(this.member, this.achievement);
}

class DeleteAchievementEvent extends HomePageEvent {
  Member member;
  final Achievement achievement;

  DeleteAchievementEvent(this.member, this.achievement);
}

class AddDeathEvent extends HomePageEvent {
  Member member;
  final Death death;

  AddDeathEvent(this.member, this.death);
}

class DeleteDeathEvent extends HomePageEvent {
   Member member;

   DeleteDeathEvent(this.member);
}

class UpdateDeathEvent extends HomePageEvent {
  Member member;
  final Death death;

  UpdateDeathEvent(this.member, this.death);
}

class UpdateHomeEvent extends HomePageEvent {
  final FamilyTree item;

  const UpdateHomeEvent(this.item);
}

class DeleteTreeHomeEvent extends HomePageEvent {
  final FamilyTree item;

  const DeleteTreeHomeEvent(this.item);
}

class RestoreTreeHomeEvent extends HomePageEvent {
  final FamilyTree item;

  const RestoreTreeHomeEvent(this.item);
}

class JoinTreeHomeEvent extends HomePageEvent {
  final String code;

  const JoinTreeHomeEvent(this.code);
}
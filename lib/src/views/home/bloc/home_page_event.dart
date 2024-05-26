part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class LoadDataHomeEvent extends HomePageEvent {
  final List<Place>? places;
  final List<Job>? jobs;
  final List<AchievementType>? achievementTypes;
  final List<RelationshipType>? relationshipTypes;
  final List<CauseOfDeath>? deathCauses;
  final List<Member>? members;

  const LoadDataHomeEvent({
    this.places,
    this.jobs,
    this.achievementTypes,
    this.relationshipTypes,
    this.deathCauses,
    this.members,
  });
}

class AddTreeHomeEvent extends HomePageEvent {
  final FamilyTree item;
  final Member firstMember;

  const AddTreeHomeEvent(this.item, this.firstMember);
}

class AddMemberEvent extends HomePageEvent {
  final Member member;

  const AddMemberEvent(this.member);
}

class AddAchievementEvent extends HomePageEvent {
  final Member member;
  final Achievement achievement;

  const AddAchievementEvent(this.member, this.achievement);
}

class AddDeathEvent extends HomePageEvent {
  final Member member;
  final Death death;

  const AddDeathEvent(this.member, this.death);
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
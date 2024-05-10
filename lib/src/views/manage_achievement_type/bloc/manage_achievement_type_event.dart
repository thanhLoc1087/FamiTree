part of 'manage_achievement_type_bloc.dart';

abstract class ManageAchievementTypeEvent extends Equatable {
  const ManageAchievementTypeEvent();

  @override
  List<Object> get props => [];
}

class LoadDataAchievementTypeEvent extends ManageAchievementTypeEvent {
  final List<AchievementType> items;

  const LoadDataAchievementTypeEvent(this.items);
}

class AddAchievementTypeEvent extends ManageAchievementTypeEvent {
  final AchievementType item;

  const AddAchievementTypeEvent(this.item);
}

class UpdateAchievementTypeEvent extends ManageAchievementTypeEvent {
  final AchievementType item;

  const UpdateAchievementTypeEvent(this.item);
}

class DeleteAchievementTypeEvent extends ManageAchievementTypeEvent {
  final AchievementType item;

  const DeleteAchievementTypeEvent(this.item);
}

class RestoreAchievementTypeEvent extends ManageAchievementTypeEvent {
  final AchievementType item;

  const RestoreAchievementTypeEvent(this.item);
}
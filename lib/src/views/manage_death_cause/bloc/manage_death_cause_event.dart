part of 'manage_death_cause_bloc.dart';

abstract class ManageDeathCauseEvent extends Equatable {
  const ManageDeathCauseEvent();

  @override
  List<Object> get props => [];
}

class LoadDataDeathCauseEvent extends ManageDeathCauseEvent {
  final List<CauseOfDeath> items;

  const LoadDataDeathCauseEvent(this.items);
}

class AddDeathCauseEvent extends ManageDeathCauseEvent {
  final CauseOfDeath item;

  const AddDeathCauseEvent(this.item);
}

class UpdateDeathCauseEvent extends ManageDeathCauseEvent {
  final CauseOfDeath item;

  const UpdateDeathCauseEvent(this.item);
}

class DeleteDeathCauseEvent extends ManageDeathCauseEvent {
  final CauseOfDeath item;

  const DeleteDeathCauseEvent(this.item);
}

class RestoreDeathCauseEvent extends ManageDeathCauseEvent {
  final CauseOfDeath item;

  const RestoreDeathCauseEvent(this.item);
}
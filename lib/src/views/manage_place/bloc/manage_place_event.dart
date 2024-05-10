part of 'manage_place_bloc.dart';

abstract class ManagePlaceEvent extends Equatable {
  const ManagePlaceEvent();

  @override
  List<Object> get props => [];
}

class LoadDataPlaceEvent extends ManagePlaceEvent {
  final List<Place> places;

  const LoadDataPlaceEvent(this.places);
}

class AddPlaceEvent extends ManagePlaceEvent {
  final Place place;

  const AddPlaceEvent(this.place);
}

class UpdatePlaceEvent extends ManagePlaceEvent {
  final Place place;

  const UpdatePlaceEvent(this.place);
}

class DeletePlaceEvent extends ManagePlaceEvent {
  final Place place;

  const DeletePlaceEvent(this.place);
}

class RestorePlaceEvent extends ManagePlaceEvent {
  final Place place;

  const RestorePlaceEvent(this.place);
}
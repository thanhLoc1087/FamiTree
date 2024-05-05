
import 'package:equatable/equatable.dart';
import 'package:famitree/src/data/repositories/place_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_place_event.dart';
part 'manage_place_state.dart';

class ManagePlaceBloc extends Bloc<ManagePlaceEvent, ManagePlaceState> {
  final PlaceRepository placeRepository;
  
  ManagePlaceBloc(this.placeRepository) : super(ManagePlaceInitial()) {
    on<ManagePlaceEvent>((event, emit) {
    });
  }
}

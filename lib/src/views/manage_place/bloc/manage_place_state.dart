// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_place_bloc.dart';

class ManagePlaceState extends Equatable {
  const ManagePlaceState({
    this.places = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<Place> places;
  
  @override
  List<Object> get props => [ isLoading, places ];

  ManagePlaceState copyWith({
    bool? isLoading,
    List<Place>? places,
  }) {
    return ManagePlaceState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
    );
  }
}


class ErrorUpdateManagePlaceState extends ManagePlaceState {
  const ErrorUpdateManagePlaceState({
    super.places = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateManagePlaceState.fromManagePlaceState(
    ManagePlaceState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateManagePlaceState(
      places: mps.places,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateManagePlaceState extends ManagePlaceState {
  const CompleteUpdateManagePlaceState({
    super.places = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateManagePlaceState.fromManagePlaceState(
      ManagePlaceState mps) {
    return CompleteUpdateManagePlaceState(
      places: mps.places,
      isLoading: mps.isLoading,
    );
  }
}

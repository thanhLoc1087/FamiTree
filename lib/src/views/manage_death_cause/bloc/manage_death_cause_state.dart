// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_death_cause_bloc.dart';

class ManageDeathCauseState extends Equatable {
  const ManageDeathCauseState({
    this.items = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<CauseOfDeath> items;
  
  @override
  List<Object> get props => [ isLoading, items ];

  ManageDeathCauseState copyWith({
    bool? isLoading,
    List<CauseOfDeath>? items,
  }) {
    return ManageDeathCauseState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}


class ErrorUpdateManageDeathCauseState extends ManageDeathCauseState {
  const ErrorUpdateManageDeathCauseState({
    super.items = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateManageDeathCauseState.fromManageDeathCauseState(
    ManageDeathCauseState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateManageDeathCauseState(
      items: mps.items,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateManageDeathCauseState extends ManageDeathCauseState {
  const CompleteUpdateManageDeathCauseState({
    super.items = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateManageDeathCauseState.fromManageDeathCauseState(
      ManageDeathCauseState mps) {
    return CompleteUpdateManageDeathCauseState(
      items: mps.items,
      isLoading: mps.isLoading,
    );
  }
}

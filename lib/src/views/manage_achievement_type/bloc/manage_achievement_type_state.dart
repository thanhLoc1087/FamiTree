// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_achievement_type_bloc.dart';

class ManageAchievementTypeState extends Equatable {
  const ManageAchievementTypeState({
    this.items = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<AchievementType> items;
  
  @override
  List<Object> get props => [ isLoading, items ];

  ManageAchievementTypeState copyWith({
    bool? isLoading,
    List<AchievementType>? items,
  }) {
    return ManageAchievementTypeState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}


class ErrorUpdateManageAchievementTypeState extends ManageAchievementTypeState {
  const ErrorUpdateManageAchievementTypeState({
    super.items = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateManageAchievementTypeState.fromManageAchievementTypeState(
    ManageAchievementTypeState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateManageAchievementTypeState(
      items: mps.items,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateManageAchievementTypeState extends ManageAchievementTypeState {
  const CompleteUpdateManageAchievementTypeState({
    super.items = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateManageAchievementTypeState.fromManageAchievementTypeState(
      ManageAchievementTypeState mps) {
    return CompleteUpdateManageAchievementTypeState(
      items: mps.items,
      isLoading: mps.isLoading,
    );
  }
}

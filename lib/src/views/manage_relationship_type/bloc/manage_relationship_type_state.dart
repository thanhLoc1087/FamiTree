// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_relationship_type_bloc.dart';

class ManageRelationshipTypeState extends Equatable {
  const ManageRelationshipTypeState({
    this.items = const [],
    this.isLoading = false,
  });

  final bool isLoading;
  final List<RelationshipType> items;
  
  @override
  List<Object> get props => [ isLoading, items ];

  ManageRelationshipTypeState copyWith({
    bool? isLoading,
    List<RelationshipType>? items,
  }) {
    return ManageRelationshipTypeState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
    );
  }
}


class ErrorUpdateManageRelationshipTypeState extends ManageRelationshipTypeState {
  const ErrorUpdateManageRelationshipTypeState({
    super.items = const [],
    super.isLoading = false,
    this.errorMessage = "",
  });

  final String errorMessage;

  factory ErrorUpdateManageRelationshipTypeState.fromManageRelationshipTypeState(
    ManageRelationshipTypeState mps, {
    String? errorMessage,
  }) {
    return ErrorUpdateManageRelationshipTypeState(
      items: mps.items,
      isLoading: mps.isLoading,
      errorMessage: errorMessage ?? ''
    );
  }
}

class CompleteUpdateManageRelationshipTypeState extends ManageRelationshipTypeState {
  const CompleteUpdateManageRelationshipTypeState({
    super.items = const [],
    super.isLoading = false,
  });

  factory CompleteUpdateManageRelationshipTypeState.fromManageRelationshipTypeState(
      ManageRelationshipTypeState mps) {
    return CompleteUpdateManageRelationshipTypeState(
      items: mps.items,
      isLoading: mps.isLoading,
    );
  }
}

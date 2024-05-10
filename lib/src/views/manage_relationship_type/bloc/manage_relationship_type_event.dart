part of 'manage_relationship_type_bloc.dart';

abstract class ManageRelationshipTypeEvent extends Equatable {
  const ManageRelationshipTypeEvent();

  @override
  List<Object> get props => [];
}

class LoadDataRelationshipTypeEvent extends ManageRelationshipTypeEvent {
  final List<RelationshipType> items;

  const LoadDataRelationshipTypeEvent(this.items);
}

class AddRelationshipTypeEvent extends ManageRelationshipTypeEvent {
  final RelationshipType item;

  const AddRelationshipTypeEvent(this.item);
}

class UpdateRelationshipTypeEvent extends ManageRelationshipTypeEvent {
  final RelationshipType item;

  const UpdateRelationshipTypeEvent(this.item);
}

class DeleteRelationshipTypeEvent extends ManageRelationshipTypeEvent {
  final RelationshipType item;

  const DeleteRelationshipTypeEvent(this.item);
}

class RestoreRelationshipTypeEvent extends ManageRelationshipTypeEvent {
  final RelationshipType item;

  const RestoreRelationshipTypeEvent(this.item);
}
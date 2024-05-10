import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/services/relationship_type_services/relationship_type_firebase_service.dart';

class RelationshipTypeRepository {
  late RelationshipTypeRemoteService remoteService;

  RelationshipTypeRepository() {
    remoteService = RelationshipTypeRemoteService();
  }

  Future<List<RelationshipType>> getAllRelationshipTypes()
  => remoteService.getAllRelationshipTypes();

  Future<RelationshipType?> getRelationshipTypeById(String typeId)
  => remoteService.getRelationshipTypeById(typeId);

  Future<bool> addRelationshipType(RelationshipType type)
  => remoteService.addRelationshipType(type);

  Future<int> updateRelationshipType(
    RelationshipType type, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateRelationshipType(type, updateData: updateData);

  Future<int> deleteRelationshipType(RelationshipType type)
  => remoteService.deleteRelationshipType(type);
}

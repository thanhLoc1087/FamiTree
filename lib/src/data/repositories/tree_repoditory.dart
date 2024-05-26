import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/tree_services/tree_firebase_service.dart';

class TreeRepository {
  late TreeRemoteService remoteService;

  TreeRepository() {
    remoteService = TreeRemoteService();
  }

  Future<List<FamilyTree>> getAllTrees()
  => remoteService.getAllTrees();

  Future<FamilyTree?> getTreeById(String id)
  => remoteService.getTreeById(id);

  Future<FamilyTree?> getTreeByCode(String code)
  => remoteService.getTreeByCode(code);

  Future<bool> addTree(
    MyUser user,
    FamilyTree item,
    Member firstMember,
  ) => remoteService.addTree(user, item, firstMember);

  Future<int> updateTree(
    FamilyTree item, {
    Map<String, dynamic>? updateData,
  }) => remoteService.updateTree(item, updateData: updateData);

  Future<int> deleteTree(FamilyTree item)
  => remoteService.deleteTree(item);
}

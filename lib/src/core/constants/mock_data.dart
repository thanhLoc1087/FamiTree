// import 'package:famitree/src/data/models/achievement.dart';
// import 'package:famitree/src/data/models/achievement_type.dart';
// import 'package:famitree/src/data/models/family_tree.dart';
// import 'package:famitree/src/data/models/member.dart';
// import 'package:famitree/src/data/models/place.dart';
// import 'package:famitree/src/data/models/relationship_type.dart';

// class MockData {
//   static List<Place> places = [
//     const Place(id: 'ag', name: 'An Giang', address: '806 Hickle Valley, Tulaborough, MI 15501-0750', quantity: 0),
//     const Place(id: 'hn', name: 'Hà Nội', address: 'Suite 486 7688 Rosetta Rest, Watsicamouth, SC 03844-2020', quantity: 0),
//     const Place(id: 'bg', name: 'Bắc Giang', address: '72767 Howell Tunnel, Lake Stanton, IA 23178', quantity: 0),
//     const Place(id: 'hcm', name: 'Hồ Chí Minh', address: '2407 Kirk Isle, Armandtown, OR 22563-1710', quantity: 0),
//   ];

//   static List<AchievementType> achievementTypes = [
//     const AchievementType(id: 'hg', name: 'Học Sinh giỏi', description: "Đạt thành tích hSG", quantity: 0),
//     const AchievementType(id: 'tn', name: 'Tốt nghiệp', description: "Tốt nghiệp THPT", quantity: 0),
//     const AchievementType(id: 'nobel', name: 'Giải Nobel', description: "Đạt giải Nobel", quantity: 0),
//   ];

//   static List<Achievement> achievements = [
//     Achievement(type: achievementTypes[0], time: DateTime.now()),
//     Achievement(type: achievementTypes[1], time: DateTime.now()),
//     Achievement(type: achievementTypes[2], time: DateTime.now()),
//   ];

//   static List<RelationshipType> relationshipTypes = [
//     const RelationshipType(id: 'chacon', name: "Cha - con", description: "Cha - con", quantity: 0),
//     const RelationshipType(id: 'vochong', name: "Vợ - Chồng", description: "Vợ - Chồng", quantity: 0),
//   ];

//   static List<FamilyTree> trees = [
//     FamilyTree(id: '111', createdAt: DateTime.now(), lastUpdatedAt: DateTime.now(), treeCode: '111'),
//   ];

//   static List<Member> members = [
//     Member(
//       name: "Lê Thành Lộc", 
//       homeland: places[0],
//       treeCode: trees[0].id, 
//       id: '',
//     ),
//   ];
// }
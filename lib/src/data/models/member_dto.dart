

// FamilyMember familyTree = FamilyMember(
//   name: 'Grandparent',
//   spouse: FamilyMember(name: 'Grandparent Spouse'),
//   children: [
//     FamilyMember(
//       name: 'Parent 1',
//       spouse: FamilyMember(name: 'Parent 1 Spouse'),
//     ),
//     FamilyMember(
//       name: 'Parent 2',
//       spouse: FamilyMember(name: 'Parent 2 Spouse'),
//       children: [
//         FamilyMember(
//           name: 'Child 3',
//           spouse: FamilyMember(name: 'Chil3 Spouse')
//         ),
//         FamilyMember(name: 'Child 4'),
//       ],
//     ),
//   ],
// );


class FamilyMember {
  final String name;
  final List<FamilyMember> children;
  final FamilyMember? spouse;
  final bool isDead;

  FamilyMember({required this.name, this.children = const [], this.spouse, this.isDead = false});
}
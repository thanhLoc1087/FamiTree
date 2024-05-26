
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:flutter/material.dart';

class FamilyTreeWidget extends StatelessWidget {
  final FamilyTree familyTree;

  const FamilyTreeWidget({super.key, required this.familyTree});

  @override
  Widget build(BuildContext context) {
    // return CustomPaint(
    //   painter: FamilyTreePainter(familyTree),
    //   child: FamilyMemberWidget(member: familyTree),
    // );
    return Column(
      children: [
        Text(
          'Tree name: ${familyTree.name}'
        ),
        Text(
          'Tree code: ${familyTree.treeCode}'
        ),
        Expanded(
          child: FamilyMemberWidget(member: familyTree.firstMember!,)
        ),        
      ],
    );
  }
}

class FamilyMemberWidget extends StatelessWidget {
  final Member member;

  const FamilyMemberWidget({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                memberNode(context, member.name),
                if (member.spouse != null) ...[
                  const Text(' - '),
                  memberNode(
                    context, 
                    member.spouse!.name, 
                    borderColor: member.spouse?.isDead == true ? AppColor.dead : AppColor.spouse
                  ),
                ],
              ],
            ),
          ),
          if (member.children?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: member.children!.map((child) => FamilyMemberWidget(member: child)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget memberNode(
    BuildContext context,
    String name, {
    Color? borderColor,
  }) {
    return InkWell(
      onTap: () async {
        // final data = await showDialog(
        //     context: context,
        //     builder: (context) {
        //       return const MemberAchievementForm(
        //         selectedMember: ,
        //       );
        //     },
        //   );
        //   if (data != null) {
        //     debugPrint(data);
        //   }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0), // Padding inside the border
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? AppColor.primary,
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(8.0), // Optional: border radius for rounded corners
        ),
        width: 120,
        child: Center(
          child: Text(
            name, 
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
        )),
    );
  }
}

// class FamilyTreePainter extends CustomPainter {
//   final FamilyMember familyTree;
//   final double nodeHeight = 60;
//   final double nodeWidth = 100;
//   final double verticalSpacing = 50;
//   final double horizontalSpacing = 20;

//   FamilyTreePainter(this.familyTree);

//   @override
//   void paint(Canvas canvas, Size size) {
//     _drawConnections(canvas, familyTree, Offset(size.width / 2, nodeHeight / 2));
//   }

//   void _drawConnections(Canvas canvas, FamilyMember member, Offset offset) {
//     final Paint paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.0;

//     // Draw line to spouse
//     if (member.spouse != null) {
//       final spouseOffset = offset + Offset(horizontalSpacing, 0);
//       canvas.drawLine(offset, spouseOffset, paint);
//     }

//     // Draw lines to children
//     if (member.children.isNotEmpty) {
//       for (int i = 0; i < member.children.length; i++) {
//         final child = member.children[i];
//         final childOffset = offset + Offset(0, verticalSpacing + i * (nodeHeight + verticalSpacing));
//         canvas.drawLine(offset, childOffset, paint);
//         _drawConnections(canvas, child, childOffset);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
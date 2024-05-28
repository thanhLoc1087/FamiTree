
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FamilyTreeWidget extends StatelessWidget {
  final FamilyTree familyTree;
  final bool readOnly;

  const FamilyTreeWidget({super.key, required this.familyTree, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    // return CustomPaint(
    //   painter: FamilyTreePainter(familyTree),
    //   child: FamilyMemberWidget(member: familyTree),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tree name: ${familyTree.name}',
                    textAlign: TextAlign.start,
                  ),
                  if (familyTree.editors.contains(CurrentUser().user.uid))
                  Text(
                    'Tree code: ${familyTree.treeCode}',
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  if(MediaQuery.of(context).orientation == Orientation.portrait) 
                  { 
                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]); 
                  }else { 
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); 
                  } 
                },
                icon: const Icon(Icons.screen_rotation_alt_rounded)
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: FamilyMemberWidget(member: familyTree.firstMember!, readOnly: readOnly)
          ),        
        ],
      ),
    );
  }
}

class FamilyMemberWidget extends StatelessWidget {
  final Member member;
  final bool readOnly;
  const FamilyMemberWidget({super.key, required this.member, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  memberNode(context, member, readOnly),
                  if (member.spouse != null) ...[
                    const Text(' - '),
                    memberNode(
                      context, 
                      member.spouse!, 
                      readOnly,
                      borderColor: member.spouse?.isDead == true ? AppColor.dead : AppColor.spouse,
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
                  children: member.children!.map((child) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FamilyMemberWidget(member: child, readOnly: readOnly,),
                  )).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget memberNode(
    BuildContext context,
    Member member, 
    bool readOnly, {
    Color? borderColor,
  }) {
    return InkWell(
      onTap: () {
        BlocProvider.of<HomePageBloc>(context).add(SelectMemberHomeEvent(member));
        Navigator.of(context).pushNamed(AppRouter.memberProfile, arguments: readOnly);
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
        width: 160,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                member.name, 
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
              Row(
                children: [
                  Icon(
                    member.isMale ? Icons.male : Icons.female,
                    color: AppColor.primary,
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    member.birthday.toDMYFormat()
                  ),
                ],
              ),
            ],
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
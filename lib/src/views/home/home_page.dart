import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/data/models/member_dto.dart';
import 'package:famitree/src/views/home/views/popup_menu_button.dart';
import 'package:flutter/material.dart';

import 'views/my_tree.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        floatingActionButton: const MyFloatingActionButton(),
        body: Center(child: FamilyTreeWidget(familyTree: familyTree,)),
      ),
    );
  }
}

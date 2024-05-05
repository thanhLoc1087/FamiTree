import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/views/home/views/popup_menu_button.dart';
import 'package:flutter/material.dart';

import 'views/tree_graphview.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        floatingActionButton: MyFloatingActionButton(),
        body: Center(
          child: TreeViewPage()
        ),
      ),
    );
  }
}
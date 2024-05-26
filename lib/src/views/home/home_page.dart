import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        body: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state.myTree == null) {
              return Center(
                child: Column(
                  children: [
                    const Text("You currently do not have a tree yet."),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {

                      }, 
                      child: const Text("Create your own tree"),
                    ),
                    const SizedBox(height: 20,),
                    
                  ],
                ),
              );
            }
            return Center(
              child: FamilyTreeWidget(
              familyTree: state.myTree!,
            ));
          },
        ),
      ),
    );
  }
}

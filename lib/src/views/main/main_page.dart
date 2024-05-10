import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/auth/views/pre_login_page.dart';
import 'package:famitree/src/views/auth/views/verify_page.dart';
import 'package:famitree/src/views/cms/cms_page.dart';
import 'package:famitree/src/views/main/views/menu_drawer.dart';
import 'package:famitree/src/views/manage_achievement_type/manage_achievement_type_page.dart';
import 'package:famitree/src/views/manage_death_cause/manage_death_cause_page.dart';
import 'package:famitree/src/views/manage_job/manage_job_page.dart';
import 'package:famitree/src/views/manage_place/manage_place_page.dart';
import 'package:famitree/src/views/manage_relationship_type/manage_relationship_type_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    // DateTime? currentBackPressTime;
    // bool onWillPop() {
    //   DateTime now = DateTime.now();
    //   if (currentBackPressTime == null ||
    //       now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    //     currentBackPressTime = now;
    //     Fluttertoast.showToast(msg: "Press again to exit app.");
    //     return false;
    //   }
    //   return true;
    // }
    return PopScope(
      canPop: true,
      child: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final googleUser = AuthService.google().currentUser;
                if (googleUser != null) {
                  return FutureBuilder(
                    future: MyUser.getCurrentUser(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.done) {
                        if (userSnapshot.data == null) {
                          AuthService.google().logout();
                          return const PreLoginPage();
                        }
                        Provider.of<CurrentUser>(context, listen: false).user =
                            userSnapshot.data!;
                        return const MainPageContent();
                      } else {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                }
                final emailUser = AuthService.firebase().currentUser;
                if (emailUser != null) {
                  final emailVerified = emailUser.isEmailVerified;
                  if (emailVerified) {
                    return FutureBuilder(
                      future: MyUser.getCurrentUser(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (userSnapshot.data == null) {
                            AuthService.firebase().logout();
                            return const PreLoginPage();
                          }
                          Provider.of<CurrentUser>(context, listen: false).user =
                              userSnapshot.data!;
                          return const HomePage();
                        } else {
                          return const Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  } else {
                    return const VerifyEmailPage();
                  }
                } else {
                  return const PreLoginPage();
                }
              default:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
            }
          }),
    );
  }
}


class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  MainPageContentState createState() => MainPageContentState();
}

class MainPageContentState extends State<MainPageContent> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        key: _sliderDrawerKey,
        appBar: SliderAppBar(
          appBarColor: Colors.white,
          title: Container()
        ),
        sliderOpenSize: 179,
        animationDuration: 200,
        slider: MenuDrawer(
          onItemClick: (index) {
            if (!kIsWeb) {
              _sliderDrawerKey.currentState!.closeSlider();
            }
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        child: Builder(
          builder: (context) {
            final selectedMenuItem = EMainMenu.values[selectedIndex];
            debugPrint("$selectedMenuItem");
            switch(selectedMenuItem) {
              case EMainMenu.home:
                if (MyUser.currentUser?.isAdmin ?? false) {
                  return const CMSPage();
                }
                return const HomePage();
              case EMainMenu.chart:
                
              case EMainMenu.profile:
                
              case EMainMenu.settings:
                
              case EMainMenu.achievementTypes:
                return const ManageAchievementTypePage();
              case EMainMenu.relationshipTypes:
                return const ManageRelationshipTypePage();
              case EMainMenu.places:
                return const ManagePlacePage();
              case EMainMenu.jobs:
                return const ManageJobPage();
              case EMainMenu.deathCauses:
                return const ManageDeathCausePage();
                
              default: return Center(child: Text(selectedMenuItem.title),);
            }
          }
        )
      )
    );
  }
}
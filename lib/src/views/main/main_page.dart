import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/auth/views/pre_login_page.dart';
import 'package:famitree/src/views/auth/views/verify_page.dart';
import 'package:famitree/src/views/cms/cms_page.dart';
import 'package:famitree/src/views/main/views/menu_drawer.dart';
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
                        debugPrint("HELLOO ${GlobalData().places}");
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
            // (MyUser.currentUser?.isAdmin ?? false) ?
            //   MainMenuItems.adminMenus[selectedIndex] :
            //   MainMenuItems.userMenus[selectedIndex];
            switch(selectedMenuItem) {
              case EMainMenu.home:
                if (MyUser.currentUser?.isAdmin ?? false) {
                  return const CMSPage();
                }
                return const HomePage();
              case EMainMenu.chart:
                // TODO: Handle this case.
              case EMainMenu.profile:
                // TODO: Handle this case.
              case EMainMenu.settings:
                // TODO: Handle this case.
              case EMainMenu.achievementTypes:
                // TODO: Handle this case.
              case EMainMenu.places:
                // TODO: Handle this case.
              case EMainMenu.jobs:
                // TODO: Handle this case.
              case EMainMenu.deathCauses:
                // TODO: Handle this case.
              default: return Center(child: Text(selectedMenuItem.title),);
            }
          }
        )
      )
    );
  }
}
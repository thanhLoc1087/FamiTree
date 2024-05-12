import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/global_var.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/auth/views/pre_login_page.dart';
import 'package:famitree/src/views/auth/views/verify_page.dart';
import 'package:famitree/src/views/cms/cms_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';
import 'views/drawer.dart';


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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GlobalVar.scaffoldState.currentState
                ?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: AppColor.text,
          ),
        ),
      ),
      key: GlobalVar.scaffoldState,
      backgroundColor: AppColor.background,
      extendBodyBehindAppBar: true,
      drawer: const ShopMenuDrawer(),
      body: Builder(
        builder: (context) {
          if (MyUser.currentUser?.isAdmin ?? false) {
            return const CMSPage();
          }
          return const HomePage();
        }, 
      ) 
    );
  }
}
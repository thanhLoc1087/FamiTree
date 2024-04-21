import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/auth/views/pre_login_page.dart';
import 'package:famitree/src/views/auth/views/verify_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    bool onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press again to exit app.");
        return false;
      }
      return true;
    }
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
        slider: _SliderView(
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
            switch(selectedMenuItem) {
              case EMainMenu.home:
                return const HomePage();
              case EMainMenu.chart:
                // TODO: Handle this case.
              case EMainMenu.profile:
                // TODO: Handle this case.
              case EMainMenu.settings:
                // TODO: Handle this case.
              default: return Center(child: Text(selectedMenuItem.title),);
            }
          }
        )
      )
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(int)? onItemClick;

  const _SliderView({super.key, this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: AppColor.interactive,
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(AppImage.defaultProfile),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Nick',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.text,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...EMainMenu.values
              .map((menu) => _SliderMenuItem(
                  item: menu,
                  iconData: menu.iconData,
                  onTap: onItemClick)),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final EMainMenu item;
  final IconData iconData;
  final Function(int)? onTap;

  const _SliderMenuItem(
      {super.key,
      required this.item,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(item.title,
            style: TextStyle(
                color: AppColor.text, fontFamily: 'Averta_Regular')),
        leading: Icon(iconData, color: AppColor.text),
        onTap: () => onTap?.call(EMainMenu.values.indexOf(item)));
  }
}
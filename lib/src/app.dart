import 'package:famitree/src/core/constants/colors.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/enums/main_menu.dart';
import 'views/main/main_page.dart';
import 'views/settings/settings_controller.dart';
import 'views/settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return const MainPage();
                }
              },
            );
          },
        );
      },
    );
  }
}

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  late final ValueNotifier<EMainMenu> _selectedTab;
  @override
  void initState() {
    _selectedTab = ValueNotifier(EMainMenu.home);
    super.initState();
  }

  void _handleIndexChanged(int i) {
    _selectedTab.value = EMainMenu.values[i];
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: ValueListenableBuilder(
          valueListenable: _selectedTab,
          builder: (BuildContext context, EMainMenu value, Widget? child) { 
           return Center(
            child: Text(value.name),
           );
          },
        ),
        extendBody: true,
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _selectedTab,
          builder: (BuildContext context, EMainMenu value, Widget? child) { 
            return FlashyTabBar(
              selectedIndex: EMainMenu.values.indexOf(value),
              showElevation: true,
              backgroundColor: AppColor.interactive,
              onItemSelected: _handleIndexChanged,
              items: EMainMenu.values.map((e) => 
                FlashyTabBarItem(
                  icon: Icon(e.iconData),
                  title: Text(e.name),
                  activeColor: AppColor.text,
                  inactiveColor: AppColor.accent,
                ),
              ).toList(),
            );
          }
        ),
      ),
    );
  }
}



/// Family tree
/// 1. Cây của mình
///   Mã chia sẻ cây
///   Thêm, xóa, sửa tv
///   Mời đóng góp
///   Xuất ảnh
/// 2. Thành tích
/// 3. Xem cây người khác
/// 4. Cài đặt 
///   Xóa cây
///   Xóa tài khoản
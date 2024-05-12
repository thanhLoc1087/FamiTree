import 'package:famitree/src/core/enums/main_menu.dart';

class MainMenuItems {
  static List<EMainMenu> userMenus = [
    EMainMenu.home,
    EMainMenu.chart,
    EMainMenu.profile,
    EMainMenu.settings,
    EMainMenu.updateProfile,
    EMainMenu.forgotPassword,
    EMainMenu.logout,
  ];

  static List<EMainMenu> adminMenus = [
    EMainMenu.relationshipTypes,
    EMainMenu.places,
    EMainMenu.jobs,
    EMainMenu.achievementTypes,
    EMainMenu.deathCauses,
    EMainMenu.updateProfile,
    EMainMenu.forgotPassword,
    EMainMenu.logout,
  ];
}
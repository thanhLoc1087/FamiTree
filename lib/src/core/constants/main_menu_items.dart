import 'package:famitree/src/core/enums/main_menu.dart';

class MainMenuItems {
  static List<EMainMenu> userMenus = [
    EMainMenu.home,
    EMainMenu.chart,
    EMainMenu.profile,
    EMainMenu.settings,
  ];

  static List<EMainMenu> adminMenus = [
    EMainMenu.achievementTypes,
    EMainMenu.places,
    EMainMenu.jobs,
    EMainMenu.deathCauses,
  ];
}
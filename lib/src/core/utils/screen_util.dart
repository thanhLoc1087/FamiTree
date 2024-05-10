import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenUtils {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static EdgeInsets viewPadding = EdgeInsets.zero;

  static void init(context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    viewPadding = MediaQuery.of(context).viewPadding;
  }

  static bool isTablet() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? false : true;
  }

  static void setPortraitMode() {
    // if (isTablet()) {
    //   return;
    // }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static void showStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static void hideStatusBar() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
  }
}

extension ScreenExt on num {
  double get height => this * ScreenUtils.screenHeight / 100;

  double get width => this * ScreenUtils.screenWidth / 100;
}

// ignore: avoid_web_libraries_in_flutter
// import 'dart:js' as js;
import 'package:famitree/src/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, warning, error, info }

extension ExtType on ToastType {
  ToastificationType toWebType() {
    switch (this) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.info:
        return ToastificationType.info;
    }
  }
}

class Toasty {
  static DateTime lastToast = DateTime.now();
  static String lastToastMess = "";

  static void show(
    String message, {
    String title = "Thông báo",
    ToastType type = ToastType.success,
    bool isLongToast = false,
    BuildContext? context,
  }) {
    if (DateTime.now().difference(lastToast) < const Duration(seconds: 3) &&
        message == lastToastMess) {
      return;
    }
    lastToast = DateTime.now();
    lastToastMess = message;

    Fluttertoast.showToast(
      msg: message,
      toastLength: isLongToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: type == ToastType.success
          ? Colors.green
          : (type == ToastType.warning
              ? Colors.orange
              : (type == ToastType.success ? Colors.white : Colors.red)),
      textColor: type == ToastType.success
          ? AppColor.background
          : Colors.white,
      fontSize: 14.0,
    );
  }
}

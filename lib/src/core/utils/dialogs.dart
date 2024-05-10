import 'package:flutter/material.dart';

class DialogUtils {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool isShowDialog = false;
  static Future<void> showMessageDialog(BuildContext context, String message, {String title = 'Hi there'}) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions:  [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('OK')),
        ],
      );
    });
  }

  static void showLoading() {
    if (navigatorKey.currentContext != null) {
      isShowDialog = true;
      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return const CircularProgressIndicator();
        },
      ).then((value) => isShowDialog = false);
    }
  }

  static void hideLoading() {
    if (navigatorKey.currentContext != null) {
      if (isShowDialog) {
        Navigator.pop(navigatorKey.currentContext!);
        isShowDialog = false;
      }
    }
  }

  static Future<bool> showLogOutDialog(BuildContext context, {required String title, required String content}) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Confirm')),
            ],
          );
        }).then((value) => value ?? false);
  }
}
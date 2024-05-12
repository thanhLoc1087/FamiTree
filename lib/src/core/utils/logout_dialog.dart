import 'package:famitree/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context, {required String title, required String content}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.background,
          title: Text(
            title,
            style: const TextStyle(
              color: AppColor.text
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              color: AppColor.text
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColor.text
                ),)),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: AppColor.danger
                ),
              )),
          ],
        );
      }).then((value) => value ?? false);
}
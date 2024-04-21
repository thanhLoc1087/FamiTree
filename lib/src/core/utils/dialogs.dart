
import 'package:flutter/material.dart';

Future<void> showMessageDialog(BuildContext context, String message, {String title = 'Hi there'}) {
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

Future<bool> showLogOutDialog(BuildContext context, {required String title, required String content}) {
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
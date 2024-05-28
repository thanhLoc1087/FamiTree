import 'package:famitree/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ButtonBack extends StatelessWidget {
  final Color? customColor;

  const ButtonBack({
    super.key,
    this.onPressed,
    this.customColor,
    this.showCloseButton = false,
  });

  final VoidCallback? onPressed;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      color: customColor ?? AppColor.primary,
      icon: Icon(
        showCloseButton ? Icons.delete : Icons.arrow_back
      ),
    );
  }
}

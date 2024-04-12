import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class OrdinaryButton extends StatelessWidget {
  const OrdinaryButton({
    super.key, 
    required this.onPressed, this.textStyle, required this.text, this.backgroundColor
  });
  final void Function() onPressed;
  final TextStyle? textStyle;
  final String text;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? AppColor.interactive),
      ),
      child: Text(
        text,
        style: textStyle ?? AppTextStyles.body,
      )
    );
  }
}
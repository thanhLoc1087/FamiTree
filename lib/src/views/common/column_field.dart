import 'package:famitree/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ColumnField extends StatelessWidget {
  const ColumnField({super.key, required this.name, this.color});

  final String name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        name,
        style: TextStyle(
          color: color ?? AppColor.text,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        softWrap: true,
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
  }
}

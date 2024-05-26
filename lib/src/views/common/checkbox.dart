import 'package:famitree/src/core/constants/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CheckBoxSection extends StatefulWidget {
  final String text;
  final ValueChanged<bool> onChanged;
  bool initValue;

  CheckBoxSection({
    super.key,
    required this.text,
    required this.onChanged,
    required this.initValue,
  });

  @override
  State<CheckBoxSection> createState() => _CheckBoxSectionState();
}

class _CheckBoxSectionState extends State<CheckBoxSection> {
  late bool isCheck;

  @override
  void initState() {
    super.initState();
    isCheck = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isCheck = !isCheck;
          widget.onChanged(isCheck);
        });
      },
      child: Row(
        children: [
          Checkbox(
            checkColor: AppColor.primary,
            side: const BorderSide(color: AppColor.primary),
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              return AppColor.background;
            }),
            value: isCheck,
            onChanged: (bool? value) {
              setState(() {
                isCheck = value!;
                widget.onChanged(value);
              });
            },
          ),
          Text(
            widget.text,
            style: const TextStyle(
              color: AppColor.text,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

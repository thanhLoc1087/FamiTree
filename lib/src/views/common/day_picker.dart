import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/datetime_utils.dart';
import 'package:flutter/material.dart';

class DayPicker extends StatefulWidget {
  const DayPicker({super.key, this.onChanged, this.initTime});
  final void Function(DateTime?)? onChanged;
  final DateTime? initTime;

  @override
  State<DayPicker> createState() =>
      _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  late DateTime datetime;
  @override
  void initState() {
    datetime = widget.initTime ?? DateTime.now();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: datetime,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColor.text,
                ),
              ),
              child: child!,
            );
          },
        ).then((value) {
          setState(() {
            datetime = value ?? (datetime = DateTime.now());
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.interactive,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  DateTimeUtils.formatDate(datetime),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColor.text,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const SizedBox(
              width: 15, height: 15,
              child: Icon(
                Icons.calendar_month_outlined
              ),
            )
          ],
        ),
      ),
    );
  }
}

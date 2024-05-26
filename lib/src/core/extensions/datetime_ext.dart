import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension ExtInt on int {
  String toWeekDayStr() {
    List<String> name = ["", "2", "3", "4", "5", "6", "7", "CN"];
    return name[this];
  }

  String toWeekDayFullStr() {
    List<String> name = [
      "",
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "C.Nhật"
    ];
    return name[this];
  }
}

extension ExtTime on TimeOfDay {
  String toTimeString({bool symbol = false}) {
    String hour = "${this.hour}".padLeft(2, '0');
    String minute = "${this.minute}".padLeft(2, '0');
    if (symbol) {
      return "${hour}h$minute'";
    }
    return "$hour:$minute";
  }
}

extension ExtDouble on double {
  String toTimeString({bool short = false, bool accept24h = false}) {
    int hour = toInt();
    int minutes = ((this - toInt()) * 60).toInt();
    if (accept24h) {
      if (hour == 0 && minutes == 0) {
        return short ? "24h" : "24h00";
      }
    }

    String m = "$minutes".padLeft(2, '0');
    if (short && minutes == 0) {
      m = "";
    }
    return "${hour}h$m";
  }

  String toTime({bool short = false, bool accept24h = false}) {
    int hour = toInt();
    int minutes = ((this - toInt()) * 60).toInt();
    if (accept24h) {
      if (hour == 0 && minutes == 0) {
        return short ? "24" : "24:00";
      }
    }

    String m = "$minutes".padLeft(2, '0');
    if (short) {
      if (minutes == 0) {
        return "$hour";
      }
    }
    return "$hour:$m";
  }

  String toTimeSep() {
    int hour = toInt();
    int minutes = ((this - toInt()) * 60).toInt();
    return "${"$hour".padLeft(2, '0')}:${"$minutes".padLeft(2, '0')}";
  }

  String toText({int? digits}) {
    if (this == toInt()) return "${toInt()}";
    if (digits != null) {
      return toStringAsFixed(digits);
    }
    return "$this";
  }

  double floorTo(double fraction) {
    int i = (this / fraction).floor();
    return i * fraction;

    // int i = 0;
    // for (;; i++) {
    //   double res = i * fraction;
    //   if (res > this) {
    //     i--;
    //     break;
    //   }
    // }
    // return i * fraction;
  }

  String toAmountMinutes({bool showZero = false, required int step}) {
    double realTime = this * step / 60;

    int hour = realTime.toInt();
    int minutes = ((realTime - hour) * 60).toInt();

    String sHour = "", sMin = "";
    if (hour > 0) {
      sHour = "${hour}h";
    }
    if (minutes > 0) {
      sMin = "${minutes}p";
    }
    if (showZero && hour == 0 && minutes == 0) {
      return "0";
    }
    return "$sHour$sMin";
  }
}

extension ExtDateTime on DateTime {
  String toYMDFormat() {
    String result = DateFormat("yyyy-MM-dd").format(this);
    return result;
  }

  String toDMYFormat() {
    String result = DateFormat("dd/MM/yyyy").format(this);
    return result;
  }

  String toDayFormat() {
    String result = DateFormat("dd").format(this);
    return result;
  }

  String toNormalDateTimeFormat() {
    String result = DateFormat("HH:mm - dd/MM/yyyy").format(this);
    return result;
  }

  String toBillFormat() {
    String result = DateFormat("dd/MM/yyyy - HH:mm").format(this);
    return result;
  }

  String toTimeFormat() {
    String result = DateFormat("HH:mm").format(this);
    return result;
  }

  String toTimeFormatLong() {
    String result = DateFormat("HH:mm:ss").format(this);
    return result;
  }

  String toWeekDayStr() {
    List<String> name = ["", "2", "3", "4", "5", "6", "7", "CN"];
    return name[weekday];
  }

  double getHourDouble() {
    return hour + minute / 60;
  }

  int cvToMinute() {
    return hour * 60 + minute;
  }

  String toSingleWeekDayStr() {
    List<String> name = [
      "",
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "Chủ Nhật"
    ];
    return name[weekday];
  }

  String toSingleWeekDayStrEnglish() {
    List<String> name = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return name[weekday];
  }

  String toNormalDateFormat() {
    String result = DateFormat("dd/MM/yyyy").format(this);
    return result;
  }

  String toDayMonthFormat() {
    String result = DateFormat("dd/MM").format(this);
    return result;
  }

  String toDayMonthFormat2() {
    String result = DateFormat("ddMM").format(this);
    return result;
  }

  String toMonthYearFormat() {
    String result = DateFormat("MM/yyyy").format(this);
    return result;
  }

  int getDaysOfMonth() {
    if ([1, 3, 5, 7, 8, 10, 12].contains(month)) {
      return 31;
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      if (year % 4 == 0) {
        if (year % 100 == 0) {
          if (year % 400 == 0) {
            return 29;
          }
        } else {
          return 29;
        }
      }
      return 28;
    }
  }

  /// Lấy index của tuần trong tháng
  /// -----
  /// index bắt đầu từ 0
  int get weekInMonth {
    int first = toFirstDayOfMonth().weekday;
    int firstWeekDays = DateTime.sunday - first + 2;
    return (day - firstWeekDays) ~/ 7 + 1;
  }

  /// Di chuyển đến ngày [dateWeek] trong tuần [weekInMonth] của tháng hiện tại
  DateTime? moveTo({
    required int dateWeek,
    required int weekInMonth,
    bool getLastMonth = true,
  }) {
    final firstMonth = toFirstDayOfMonth();
    final lastMonth = toLastDayOfMonth();

    int firstMonthWeekDay = firstMonth.weekday;
    int daysAdd = 7 * weekInMonth + dateWeek - firstMonthWeekDay;
    final res = firstMonth.add(Duration(days: daysAdd));
    if (res.compareDay(lastMonth) > 0) {
      if (getLastMonth) {
        return lastMonth;
      }
      return null;
    }
    return res;
  }

  DateTime toFirstDayOfWeek() {
    return DateTime(year, month, day).subtract(Duration(days: weekday - 1));
  }

  DateTime toPrevMonth() {
    return DateTime(year, month - 1, 1);
  }

  DateTime toNextMonth() {
    return DateTime(year, month + 1, 1);
  }

  DateTime toMonth(DateTime month) {
    return copyWith(month: month.month, year: month.year);
  }

  DateTime toPrevDay() {
    return DateTime(year, month, day - 1);
  }

  DateTime toNextDay() {
    return DateTime(year, month, day + 1);
  }

  DateTime toLastDayOfWeek() {
    return DateTime(year, month, day)
        .add(Duration(days: DateTime.daysPerWeek - weekday));
  }

  DateTime toFirstDayOfMonth() {
    return DateTime(year, month, 1);
  }

  DateTime toFirstDayOfYear() {
    return DateTime(year, 1, 1).toStartOfDate();
  }

  DateTime toLastDayOfYear() {
    return DateTime(year, 12, 31).toEndOfDate();
  }

  DateTime toLastDayOfMonth() {
    int month = this.month + 1;
    int year = this.year;
    if (month > 12) {
      month = 1;
      year++;
    }
    return DateTime(year, month, 1).subtract(const Duration(milliseconds: 1));
  }

  DateTime toStartOfDate() {
    return DateTime(year, month, day);
  }

  DateTime toEndOfDate() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  DateTime toMinuteAbsolute() {
    return DateTime(year, month, day, hour, minute, 0, 0, 0);
  }

  DateTime toDateOnly() {
    return DateTime(year, month, day);
  }

  String toNotificationTime() {
    final now = DateTime.now();
    final date = toLocal();

    String result = "";
    if (date.toNormalDateFormat() == now.toNormalDateFormat()) {
      result = "Hôm nay,";
    } else if (date.toNormalDateFormat() ==
        (now.add(const Duration(days: 1)).toNormalDateFormat())) {
      result = "Ngày mai,";
    } else if (date.toNormalDateFormat() ==
        (now.subtract(const Duration(days: 1)).toNormalDateFormat())) {
      result = "Hôm qua,";
    } else {
      if (now.year == year) {
        result = DateFormat("d MMM,", "vi").format(toLocal());
      } else {
        result = DateFormat("d MMM, yyyy", "vi").format(toLocal());
      }
    }

    result += " lúc ${DateFormat("H:mm").format(toLocal())}";
    return result;
  }

  String toNotificationTimeI18n() {
    if ("localeName".tr() == "vi") {
      return toNotificationTime();
    }

    final now = DateTime.now();
    final date = toLocal();

    String result = "";
    if (date.toNormalDateFormat() == now.toNormalDateFormat()) {
      result = "${"time.today".tr()},";
    } else if (date.toNormalDateFormat() ==
        (now.add(const Duration(days: 1)).toNormalDateFormat())) {
      result = "${"time.tomorrow".tr()},";
    } else if (date.toNormalDateFormat() ==
        (now.subtract(const Duration(days: 1)).toNormalDateFormat())) {
      result = "${"time.yesterday".tr()},";
    } else {
      if (now.year == year) {
        result = DateFormat(null, "localeName".tr()).format(toLocal());
      } else {
        result = DateFormat(null, "localeName".tr()).format(toLocal());
      }
    }
    return result;
  }

  bool sameMonth(DateTime date) {
    return month == date.month && year == date.year;
  }

  bool sameDay(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }

  int compareDay(DateTime date) {
    if (year < date.year) return -1;
    if (year > date.year) return 1;
    if (month < date.month) return -1;
    if (month > date.month) return 1;
    if (day < date.day) return -1;
    if (day > date.day) return 1;
    return 0;
  }

  bool betweenDay(DateTime d1, DateTime d2) {
    return compareDay(d1) >= 0 && compareDay(d2) <= 0;
  }

  bool inRange(DateTime start, DateTime end) {
    if (compareDay(start) >= 0 && compareDay(end) <= 0) {
      return true;
    }
    return false;
  }

  DateTime setHourMinute(double hour) {
    int h = hour.toInt();
    int m = ((hour - h) * 60).toInt();
    return copyWith(
        hour: h, minute: m, second: 0, millisecond: 0, microsecond: 0);
  }
}

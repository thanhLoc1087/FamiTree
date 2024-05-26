import 'dart:collection';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static List<String> days = ['', '2', '3', '4', '5', '6', '7', 'CN'];
  static List<String> days2 = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  static List<String> daysEn = [
    '',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  static String convertFrequentlyToDays(List<int> frequently) {
    if (frequently.length == 7) {
      return "T2 đến CN mỗi tuần";
    }
    if (frequently.length == 1 && frequently.first == DateTime.sunday) {
      return "Chủ nhật mỗi tuần";
    }
    List<String> res = [];
    for (var ele in frequently) {
      res.add(days[ele]);
    }
    return "T${res.join(', ')} hàng tuần";
  }

  static String convertFrequentlyToDaysEnglish(List<int> frequently) {
    if (frequently.length == 7) {
      return "Everyday";
    }
    List<String> res = [];
    for (var ele in frequently) {
      res.add(daysEn[ele]);
    }
    return "Every ${res.join(', ')}";
  }

  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '${hour}h$minute';
  }

  static String formatTimeOfDayWithDuration(TimeOfDay timeOfDay, int duration) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');

    int endHour = timeOfDay.hour;
    int endMinute = timeOfDay.minute + duration;
    if (endMinute >= 60) {
      endHour += endMinute ~/ 60;
      endMinute %= 60;
    }
    if (duration > 0) {
      return '${hour}h$minute - ${endHour}h${endMinute.toString().padLeft(2, '0')}';
    }
    return '${hour}h$minute - Chưa xác định';
  }

  static String formatDateTime(DateTime dateTime) {
    String time = formatTimeOfDay(
        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
    String day = formatDate(dateTime);

    return '$time - $day';
  }

  // static DateTime startDay(DateTime time) {
  //   return time.toStartOfDate();
  // }

  // static DateTime endDay(DateTime time) {
  //   return time.toEndOfDate();
  // }

  // static DateTime startMonth(DateTime time) {
  //   return DateTime(time.year, time.month, 1, 0, 0, 0);
  // }

  // static DateTime endMonth(DateTime time) {
  //   return DateTime(time.year, time.month + 1, 0, 23, 59, 59);
  // }

  static String formatDuration(int duration) {
    if (duration >= 60) {
      int hour = duration ~/ 60;
      int minute = duration % 60;

      if (minute != 0) {
        return "$hour giờ $minute phút";
      }

      return "$hour giờ";
    } else {
      return "$duration phút";
    }
  }

  static String getMMyyyy(DateTime dateTime) {
    final formatter = DateFormat('MM/yyyy');
    return formatter.format(dateTime);
  }

  static String getHHmm(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  static List<DateTime> getMatchingDatesInMonth(
      List<int> dayNumbers, DateTime month) {
    List<DateTime> matchingDates = [];
    int currentMonth = month.month;
    int currentYear = month.year;
    int currentDay = month.day;

    for (int dayNumber in dayNumbers) {
      DateTime date = DateTime(currentYear, currentMonth, currentDay);
      while (date.weekday != dayNumber) {
        date = date.add(const Duration(days: 1));
      }

      // Thêm các ngày tương ứng vào danh sách
      while (date.month == currentMonth) {
        matchingDates.add(date);
        // Cộng 7 ngày để lấy ngày trong tuần kế tiếp
        date = date.add(const Duration(days: 7));
      }
    }

    return matchingDates;
  }

  static DateTime lastDayInFrequently(DateTime date, List<int> frequently) {
    if (frequently.isEmpty) return date;
    var res = date.toNextMonth().toPrevDay();
    while (!frequently.contains(res.weekday)) {
      res = res.subtract(const Duration(days: 1));
    }
    return res;
  }

  static int compateOnlyTime(DateTime p0, DateTime p1) {
    return (p0.hour + p0.minute / 60).compareTo(p1.hour + p1.minute / 60);
  }

  static DateTime findNearestDate(List<DateTime> sortedList, DateTime target) {
    // Start with the first date in the list
    DateTime nearestDate = sortedList.first;

    for (DateTime date in sortedList) {
      // If the date is before or equal to the target, update nearestDate
      if (date.isBefore(target) || date.toDateOnly() == target.toDateOnly()) {
        nearestDate = date;
      } else {
        // As the list is sorted, once we reach a date after the target,
        // we can break the loop as the subsequent dates will also be after the target.
        break;
      }
    }
    return nearestDate;
  }

  static DateTime? getFirstDateOfFrequently(
      DateTime base, List<int> frequently) {
    for (DateTime dt = base.toFirstDayOfMonth();
        dt.compareDay(base.toNextMonth().toFirstDayOfMonth()) < 0;
        dt = dt.add(const Duration(days: 1))) {
      if (frequently.contains(dt.weekday)) {
        return dt;
      }
    }
    return null;
  }

  static DateTime? getNextDateOfFrequently(
      DateTime base, List<int> frequently) {
    for (DateTime dt = base;
        dt.compareDay(base.toNextMonth().toFirstDayOfMonth()) < 0;
        dt = dt.add(const Duration(days: 1))) {
      if (frequently.contains(dt.weekday)) {
        return dt;
      }
    }
    return null;
  }

  static DateTime min(DateTime a, DateTime b) {
    if (a.compareTo(b) < 0) return a;
    return b;
  }

  static DateTime max(DateTime a, DateTime b) {
    if (a.compareTo(b) > 0) return a;
    return b;
  }

  static DateTime? minOrNull(DateTime? a, DateTime? b) {
    if (a == null) {
      return b;
    }
    if (b == null) {
      return a;
    }
    return min(a, b);
  }

  static DateTime? maxOrNull(DateTime? a, DateTime? b) {
    if (a == null) {
      return b;
    }
    if (b == null) {
      return a;
    }
    return max(a, b);
  }

  static String toFormatHistoyTime(DateTime time) {
    final formatter = DateFormat('HH:mm - dd/MM/yyyy');
    return formatter.format(time);
  }

  static List<int> compactFrequently(
    List<int> f,
    DateTime start,
    DateTime end,
  ) {
    Set<int> freq = SplayTreeSet();

    if (end.difference(start).inDays >= 7) {
      return f;
    }
    for (var dt = start;
        dt.compareDay(end) <= 0;
        dt = dt.add(const Duration(days: 1))) {
      if (freq.contains(dt.weekday)) break;
      if (f.contains(dt.weekday)) {
        freq.add(dt.weekday);
      }
    }

    return freq.toList();
  }
}

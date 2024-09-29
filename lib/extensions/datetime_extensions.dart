// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toStatementDate() {
    return DateFormat('yMMMM').format(this);
  }

  DateTime toMonthStart() {
    return subtract(Duration(days: day));
  }

  bool isSameDay(DateTime other) {
    return other.day == day && other.month == month && other.year == year;
  }

  bool isDarkTimeOfDay() {
    // return true;
    return (hour > 20 && hour < 0) || (hour >= 0 && hour < 6);
  }

  DateTime toDayStart() {
    return DateTime(
      year,
      month,
      day,
    );
  }

  DateTime toDayEnd() {
    return DateTime(
      year,
      month,
      day,
      23,
      59,
      0,
    );
  }

  String toDayKey({
    bool withTime = false,
  }) {
    if (withTime) {
      return '${day}_${month}_${year}__${hour}_${minute}_$second';
    }
    return '${day}_${month}_$year';
  }

  DateTime subtractValues({
    int numYears = 0,
    int numMonths = 0,
    int numDays = 0,
  }) {
    return DateTime(
      year - numYears,
      month - numMonths,
      day - numDays,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime toZeroHourDate() {
    return DateTime(
      year,
      month,
      day,
    );
  }

  DateTime addDays(int numDays) {
    return DateTime(
      year,
      month,
      day + numDays,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  bool isThisYear() {
    var today = DateTime.now();
    return year == today.year;
  }

  bool isThisMonth() {
    var today = DateTime.now();
    return year == today.year && month == today.month;
  }

  bool isToday() {
    var today = DateTime.now();
    return day == today.day && month == today.month && year == today.year;
  }

  String toDashedDate() {
    return DateFormat('yyyy-MM-dd', 'en').format(
      this,
    );
  }

  String toSlashedDate() {
    return DateFormat('MM/dd/yyyy', 'en').format(
      this,
    );
  }

  String toPeriodDate() {
    return DateFormat('d MMM yyyy', 'en').format(
      this,
    );
  }

  String toDisplayTimeStamp() {
    var locale = 'en';
    var displayStamp = '';
    if (isToday()) {
      displayStamp = 'Today';
    } else if (isThisMonth()) {
      displayStamp = DateFormat('dd MMM', locale).format(
        this,
      );
    } else if (isThisYear()) {
      displayStamp = DateFormat('dd MMM yyyy', locale).format(
        this,
      );
    } else {
      displayStamp = DateFormat('dd MMM yyyy', locale).format(
        this,
      );
    }
    return displayStamp;
  }

  String toTime() {
    return DateFormat('hh:mm', 'en').format(
      this,
    );
  }

  String toNotificationTime() {
    var displayStamp = '';
    if (isToday()) {
      var time = DateFormat('hh:mm', 'en').format(
        this,
      );
      displayStamp = 'Today $time';
    } else if (isThisMonth()) {
      displayStamp = DateFormat('dd MMM, hh:mm', 'en').format(
        this,
      );
    } else if (isThisYear()) {
      displayStamp = DateFormat('dd MMM yyyy', 'en').format(
        this,
      );
    } else {
      displayStamp = DateFormat('dd MMM yyyy', 'en').format(
        this,
      );
    }
    return displayStamp;
  }

  String toCommonDateFormat() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  String toCommonDateFormatWithFullMonth() {
    return DateFormat('yMMMMd').format(this);
  }

  String toDateTimeToYearMonthFormat() {
    return DateFormat('yMMMM').format(this);
  }

  String toMonthName() {
    return DateFormat('MMMM').format(this);
  }

  String toCommonDateFormatWithTime() {
    return DateFormat('MMM dd, yyyy, hh:mm a').format(this);
  }

  String toHourMinute() {
    return DateFormat('hh:mm').format(this);
  }

  bool isSameMonth(DateTime other) {
    return other.month == month && other.year == year;
  }

  int get numDaysInMonth {
    return DateUtils.getDaysInMonth(
      year,
      month,
    );
  }

  int get numDaysInYear {
    return isLeapYear ? 366 : 365;
  }

  bool get isLeapYear {
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }

  int get dayOfYear {
    final startDate = DateTime(year);
    return difference(startDate).inDays;
  }

  int get weekNumber {
    return dayOfYear ~/ 7;
  }

  String toMessageTime([bool addExactTime = false]) {
    final formattedHours = NumberFormat('00', 'en_US').format(hour);
    final formattedMinutes = NumberFormat('00', 'en_US').format(minute);
    final onlyTime = '$formattedHours:$formattedMinutes';
    String formatted = '';
    if (isToday()) {
      return 'Today $onlyTime';
    } else if (isThisMonth()) {
      formatted = DateFormat('dd MMM', 'en').format(this);
    } else if (isThisYear()) {
      formatted = DateFormat('dd MMM yyyy', 'en').format(this);
    } else {
      formatted = DateFormat('dd MMM yyyy', 'en').format(this);
    }
    if (addExactTime) {
      return '$formatted, $onlyTime';
    }
    return formatted;
  }
}

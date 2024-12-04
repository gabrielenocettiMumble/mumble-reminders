import 'package:flutter/material.dart';

class TimeUtils {
  static TimeOfDay fromDbTime(int timeSaved) {
    return TimeOfDay(
      hour: timeSaved ~/ 60,
      minute: timeSaved % 60,
    );
  }

  static int toDbTime(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}

import 'package:flutter/material.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:va_reminders/utilities/time_utiils.dart';

mixin DbMapMixin {
  static TimeOfDay timeOfDayFromDbMap(Map<String, dynamic> map) {
    int timeSaved = map['time'];
    return TimeUtils.fromDbTime(timeSaved);
  }

  static ReminderFrequency frequencyFromDbMap(Map<String, dynamic> map) {
    return ReminderFrequency.fromDbString(map['frequency']);
  }
}

abstract class ReminderTime with DbMapMixin {
  final ReminderFrequency frequency;
  final TimeOfDay timeOfTheDay;

  const ReminderTime({
    required this.frequency,
    required this.timeOfTheDay,
  });

  ReminderTime copyWith({
    TimeOfDay? timeOfTheDay,
  });

  factory ReminderTime.fromDbMap(Map<String, dynamic> map) {
    ReminderFrequency frequency = DbMapMixin.frequencyFromDbMap(map);

    return switch (frequency) {
      ReminderFrequencyDaily() => DailyReminderTime.fromDbMap(map),
      ReminderFrequencyWeekly() => WeeklyReminderTime.fromDbMap(map),
      ReminderFrequencyMonthly() => MonthlyReminderTime.fromDbMap(map),
      ReminderFrequencyEveryThreeMonths() => MonthlyReminderTime.fromDbMap(map),
    };
  }

  Map<String, dynamic> toDbMap() => {
        'frequency': frequency.dbString,
        'time': TimeUtils.toDbTime(timeOfTheDay),
      };

  String getDescription(BuildContext context);
}

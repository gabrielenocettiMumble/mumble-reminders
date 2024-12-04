import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:va_reminders/utilities/time_utiils.dart';

void main() {
  group('DailyReminderTime', () {
    test('copyWith should return a new instance with updated values', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const dailyReminderTime = DailyReminderTime(timeOfTheDay: timeOfDay);

      const newTimeOfDay = TimeOfDay(hour: 9, minute: 0);
      final updatedDailyReminderTime =
          dailyReminderTime.copyWith(timeOfTheDay: newTimeOfDay);

      expect(updatedDailyReminderTime.timeOfTheDay, newTimeOfDay);
      expect(
          updatedDailyReminderTime.frequency, const ReminderFrequencyDaily());
    });

    test(
        'copyWith should return a new instance with original values if no parameters are provided',
        () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const dailyReminderTime = DailyReminderTime(timeOfTheDay: timeOfDay);

      final updatedDailyReminderTime = dailyReminderTime.copyWith();

      expect(updatedDailyReminderTime.timeOfTheDay, timeOfDay);
      expect(
          updatedDailyReminderTime.frequency, const ReminderFrequencyDaily());
    });

    test('fromDbMap should create an instance from a database map', () {
      final TimeOfDay now = TimeOfDay.now();
      final map = {'time': TimeUtils.toDbTime(now)};

      final timeOfDay = TimeUtils.fromDbTime(map['time']!);
      final dailyReminderTime = DailyReminderTime.fromDbMap(map);

      expect(dailyReminderTime.timeOfTheDay, timeOfDay);
      expect(dailyReminderTime.frequency, const ReminderFrequencyDaily());
    });
  });
}

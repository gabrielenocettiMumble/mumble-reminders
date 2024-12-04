import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:va_reminders/utilities/time_utiils.dart';

void main() {
  group('WeeklyReminderTime', () {
    test('copyWith should return a new instance with updated values', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const weeklyReminderTime =
          WeeklyReminderTime(timeOfTheDay: timeOfDay, dayOfWeek: 1);

      const newTimeOfDay = TimeOfDay(hour: 9, minute: 0);
      const newDayOfWeek = 2;
      final updatedWeeklyReminderTime = weeklyReminderTime.copyWith(
        timeOfTheDay: newTimeOfDay,
        dayOfWeek: newDayOfWeek,
      );

      expect(updatedWeeklyReminderTime.timeOfTheDay, newTimeOfDay);
      expect(updatedWeeklyReminderTime.dayOfWeek, newDayOfWeek);
      expect(
          updatedWeeklyReminderTime.frequency, const ReminderFrequencyWeekly());
    });

    test(
        'copyWith should return a new instance with original values if no parameters are provided',
        () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const weeklyReminderTime =
          WeeklyReminderTime(timeOfTheDay: timeOfDay, dayOfWeek: 1);

      final updatedWeeklyReminderTime = weeklyReminderTime.copyWith();

      expect(updatedWeeklyReminderTime.timeOfTheDay, timeOfDay);
      expect(updatedWeeklyReminderTime.dayOfWeek, 1);
      expect(
          updatedWeeklyReminderTime.frequency, const ReminderFrequencyWeekly());
    });

    test('fromDbMap should create an instance from a database map', () {
      final TimeOfDay now = TimeOfDay.now();
      final map = {
        'time': TimeUtils.toDbTime(now),
        'day_of_week': 3,
      };

      final timeOfDay = TimeUtils.fromDbTime(map['time']!);
      final weeklyReminderTime = WeeklyReminderTime.fromDbMap(map);

      expect(weeklyReminderTime.timeOfTheDay, timeOfDay);
      expect(weeklyReminderTime.dayOfWeek, 3);
      expect(weeklyReminderTime.frequency, const ReminderFrequencyWeekly());
    });

    test('toDbMap should return a map with correct values', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const weeklyReminderTime =
          WeeklyReminderTime(timeOfTheDay: timeOfDay, dayOfWeek: 1);

      final map = weeklyReminderTime.toDbMap();

      expect(map['time'], TimeUtils.toDbTime(timeOfDay));
      expect(map['day_of_week'], 1);
    });
  });
}

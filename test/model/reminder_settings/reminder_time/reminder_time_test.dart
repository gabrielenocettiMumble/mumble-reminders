import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:va_reminders/utilities/time_utiils.dart';

void main() {
  group('ReminderTime', () {
    test('fromDbMap should create DailyReminderTime instance', () {
      final map = {
        'frequency': 'daily',
        'time': TimeUtils.toDbTime(const TimeOfDay(hour: 8, minute: 0)),
      };

      final reminderTime = ReminderTime.fromDbMap(map);

      expect(reminderTime, isA<DailyReminderTime>());
      expect(reminderTime.frequency, const ReminderFrequencyDaily());
      expect(reminderTime.timeOfTheDay, const TimeOfDay(hour: 8, minute: 0));
    });

    test('fromDbMap should create WeeklyReminderTime instance', () {
      final map = {
        'frequency': 'weekly',
        'time': TimeUtils.toDbTime(const TimeOfDay(hour: 8, minute: 0)),
        'day_of_week': 1,
      };

      final reminderTime = ReminderTime.fromDbMap(map);

      expect(reminderTime, isA<WeeklyReminderTime>());
      expect(reminderTime.frequency, const ReminderFrequencyWeekly());
      expect(reminderTime.timeOfTheDay, const TimeOfDay(hour: 8, minute: 0));
      expect((reminderTime as WeeklyReminderTime).dayOfWeek, 1);
    });

    test('fromDbMap should create MonthlyReminderTime instance', () {
      final map = {
        'frequency': 'monthly',
        'time': TimeUtils.toDbTime(const TimeOfDay(hour: 8, minute: 0)),
        'day_of_month_number': 15,
      };

      final reminderTime = ReminderTime.fromDbMap(map);

      expect(reminderTime, isA<MonthlyReminderTime>());
      expect(reminderTime.frequency, const ReminderFrequencyMonthly());
      expect(reminderTime.timeOfTheDay, const TimeOfDay(hour: 8, minute: 0));
    });

    test('fromDbMap should create EveryThreeMonthsReminderTime instance', () {
      final map = {
        'frequency': 'every_three_months',
        'time': TimeUtils.toDbTime(const TimeOfDay(hour: 8, minute: 0)),
        'day_of_month_number': 15,
      };

      final reminderTime = ReminderTime.fromDbMap(map);

      expect(reminderTime, isA<MonthlyReminderTime>());
      expect(reminderTime.frequency, const ReminderFrequencyEveryThreeMonths());
      expect(reminderTime.timeOfTheDay, const TimeOfDay(hour: 8, minute: 0));
    });

    test('toDbMap should return a map with correct values', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const reminderTime = DailyReminderTime(
        timeOfTheDay: timeOfDay,
      );

      final map = reminderTime.toDbMap();

      expect(map['time'], TimeUtils.toDbTime(timeOfDay));
      expect(map['frequency'], 'daily');
    });

    test('copyWith should return a new instance with updated timeOfTheDay', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      const reminderTime = DailyReminderTime(
        timeOfTheDay: timeOfDay,
      );

      const newTimeOfDay = TimeOfDay(hour: 9, minute: 0);
      final updatedReminderTime = reminderTime.copyWith(
        timeOfTheDay: newTimeOfDay,
      );

      expect(updatedReminderTime.timeOfTheDay, newTimeOfDay);
      expect(updatedReminderTime.frequency, const ReminderFrequencyDaily());
    });
  });
}

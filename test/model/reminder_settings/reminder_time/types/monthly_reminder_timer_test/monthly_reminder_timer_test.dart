import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';
import 'package:va_reminders/utilities/time_utiils.dart';

void main() {
  group('MonthlyReminderTime', () {
    test('copyWith should return a new instance with only frequency updated',
        () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      final dayOfMonth = DayOfMonthNumber(15);
      final monthlyReminderTime = MonthlyReminderTime(
        frequency: const ReminderFrequencyMonthly(),
        timeOfTheDay: timeOfDay,
        dayOfMonth: dayOfMonth,
      );

      final updatedMonthlyReminderTime = monthlyReminderTime.copyWith(
        frequency: const ReminderFrequencyEveryThreeMonths(),
      );

      expect(updatedMonthlyReminderTime.timeOfTheDay, timeOfDay);
      expect(updatedMonthlyReminderTime.dayOfMonth, dayOfMonth);
      expect(updatedMonthlyReminderTime.frequency,
          const ReminderFrequencyEveryThreeMonths());
    });

    test('copyWith should return a new instance with only timeOfTheDay updated',
        () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      final dayOfMonth = DayOfMonthNumber(15);
      final monthlyReminderTime = MonthlyReminderTime(
        frequency: const ReminderFrequencyMonthly(),
        timeOfTheDay: timeOfDay,
        dayOfMonth: dayOfMonth,
      );

      const newTimeOfDay = TimeOfDay(hour: 9, minute: 0);
      final updatedMonthlyReminderTime = monthlyReminderTime.copyWith(
        timeOfTheDay: newTimeOfDay,
      );

      expect(updatedMonthlyReminderTime.timeOfTheDay, newTimeOfDay);
      expect(updatedMonthlyReminderTime.dayOfMonth, dayOfMonth);
      expect(updatedMonthlyReminderTime.frequency,
          const ReminderFrequencyMonthly());
    });

    test('copyWith should return a new instance with only dayOfMonth updated',
        () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      final dayOfMonth = DayOfMonthNumber(15);
      final monthlyReminderTime = MonthlyReminderTime(
        frequency: const ReminderFrequencyMonthly(),
        timeOfTheDay: timeOfDay,
        dayOfMonth: dayOfMonth,
      );

      final newDayOfMonth = DayOfMonthNumber(20);
      final updatedMonthlyReminderTime = monthlyReminderTime.copyWith(
        dayOfMonth: newDayOfMonth,
      );

      expect(updatedMonthlyReminderTime.timeOfTheDay, timeOfDay);
      expect(updatedMonthlyReminderTime.dayOfMonth, newDayOfMonth);
      expect(updatedMonthlyReminderTime.frequency,
          const ReminderFrequencyMonthly());
    });

    test('fromDbMap should throw an exception for invalid day of month', () {
      final map = {
        'frequency': 'monthly',
        'time': TimeUtils.toDbTime(const TimeOfDay(hour: 8, minute: 0)),
        'day_of_month_number': null,
        'last_day_of_the_month': null,
      };

      expect(() => MonthlyReminderTime.fromDbMap(map), throwsException);
    });

    test('fromDbMap should create an instance from a database map', () {
      final TimeOfDay now = TimeOfDay.now();
      final map = {
        'frequency': 'monthly',
        'time': TimeUtils.toDbTime(now),
        'day_of_month_number': 15,
      };

      final timeOfDay = TimeUtils.fromDbTime(map['time'] as int);
      final monthlyReminderTime = MonthlyReminderTime.fromDbMap(map);

      expect(monthlyReminderTime.timeOfTheDay, timeOfDay);
      expect((monthlyReminderTime.dayOfMonth as DayOfMonthNumber).day, 15);
      expect(monthlyReminderTime.frequency, const ReminderFrequencyMonthly());
    });

    test('fromDbMap should create an instance for the last day of the month',
        () {
      final TimeOfDay now = TimeOfDay.now();
      final map = {
        'frequency': 'monthly',
        'time': TimeUtils.toDbTime(now),
        'last_day_of_the_month': 1,
      };

      final timeOfDay = TimeUtils.fromDbTime(map['time'] as int);
      final monthlyReminderTime = MonthlyReminderTime.fromDbMap(map);

      expect(monthlyReminderTime.timeOfTheDay, timeOfDay);
      expect(monthlyReminderTime.dayOfMonth, isA<LastDayOfMonth>());
      expect(monthlyReminderTime.frequency, const ReminderFrequencyMonthly());
    });

    test('toDbMap should return a map with correct values', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      final dayOfMonth = DayOfMonthNumber(15);
      final monthlyReminderTime = MonthlyReminderTime(
        frequency: const ReminderFrequencyMonthly(),
        timeOfTheDay: timeOfDay,
        dayOfMonth: dayOfMonth,
      );

      final map = monthlyReminderTime.toDbMap();

      expect(map['time'], TimeUtils.toDbTime(timeOfDay));
      expect(map['day_of_month_number'], 15);
      expect(map['frequency'], 'monthly');
    });

    test('toDbMap should return a map for the last day of the month', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 0);
      final dayOfMonth = LastDayOfMonth();
      final monthlyReminderTime = MonthlyReminderTime(
        frequency: const ReminderFrequencyMonthly(),
        timeOfTheDay: timeOfDay,
        dayOfMonth: dayOfMonth,
      );

      final map = monthlyReminderTime.toDbMap();

      expect(map['time'], TimeUtils.toDbTime(timeOfDay));
      expect(map['last_day_of_the_month'], 1);
      expect(map['frequency'], 'monthly');
    });
  });
}

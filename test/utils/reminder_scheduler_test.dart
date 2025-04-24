import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_content.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:mumble_reminders/utilities/reminders_scheduler.dart';

void testWithClock(String description, Clock clock, dynamic Function() body) {
  test(description, () {
    withClock(clock, body);
  });
}

void main() {
  // Test dates for various scenarios
  final testDates = [
    // End of month dates
    DateTime(2023, 1, 31, 12, 0),
    DateTime(2023, 4, 30, 12, 0),
    DateTime(2023, 2, 28, 12, 0),
    DateTime(2024, 2, 29, 12, 0),

    // Mid-month dates
    DateTime(2023, 5, 15, 12, 0),

    // Month transitions
    DateTime(2023, 1, 30, 12, 0),
    DateTime(2023, 3, 31, 23, 59),

    // Special dates for testing day existence in different months
    DateTime(2023, 1, 29, 12, 0),
    DateTime(2023, 1, 30, 12, 0),
    DateTime(2023, 1, 31, 12, 0)
  ];

  // Reusable test functions
  void testDailyReminders(DateTime testDate) {
    testWithClock(
        'daily reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      const settings = ReminderSettings(
        time: DailyReminderTime(
          timeOfTheDay: TimeOfDay(hour: 15, minute: 0),
        ),
        content: ReminderContent(
            title: 'Daily Reminder', body: 'This is a daily reminder'),
      );

      int limit = 5;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // All reminders should be sequential days with the same time
      for (int i = 0; i < limit; i++) {
        expect(result[i].date.hour, 15);
        expect(result[i].date.minute, 0);

        // The first reminder depends on whether testDate is before or after 15:00
        if (i == 0) {
          if (testDate.hour < 15 ||
              (testDate.hour == 15 && testDate.minute == 0)) {
            // If the test date is before 15:00, the first reminder should be on the same day
            expect(result[i].date.day, testDate.day);
            expect(result[i].date.month, testDate.month);
            expect(result[i].date.year, testDate.year);
          } else {
            // If the test date is after 15:00, the first reminder should be for the next day
            final expectedDate = testDate.add(const Duration(days: 1));
            expect(result[i].date.day, expectedDate.day);
            expect(result[i].date.month, expectedDate.month);
            expect(result[i].date.year, expectedDate.year);
          }
        } else if (i > 0) {
          // Each reminder should be exactly 1 day after the previous one
          final prevDate = result[i - 1].date;
          final dayDiff = result[i].date.difference(prevDate).inDays;
          expect(dayDiff, 1);
        }
      }
    });
  }

  void testWeeklyReminders(DateTime testDate) {
    testWithClock(
        'weekly reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      final settings = ReminderSettings(
        time: WeeklyReminderTime(
          dayOfWeek: testDate.weekday % 7, // Use test date's weekday
          timeOfTheDay: const TimeOfDay(hour: 15, minute: 0),
        ),
        content: const ReminderContent(
            title: 'Weekly Reminder', body: 'This is a weekly reminder'),
      );

      int limit = 4;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // All reminders should be on the same weekday
      for (int i = 0; i < limit; i++) {
        expect(result[i].date.weekday, testDate.weekday);
        expect(result[i].date.hour, 15);
        expect(result[i].date.minute, 0);
        // Each reminder should be a week apart
        if (i > 0) {
          final dayDiff = result[i].date.difference(result[i - 1].date).inDays;
          expect(dayDiff, 7);
        }
      }
    });
  }

  void testMonthlyReminders(DateTime testDate) {
    testWithClock(
        'monthly reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyMonthly(),
          dayOfMonth: DayOfMonthNumber(testDate.day),
          timeOfTheDay: const TimeOfDay(hour: 15, minute: 0),
        ),
        content: const ReminderContent(
            title: 'Monthly Reminder', body: 'This is a monthly reminder'),
      );

      int limit = 4;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // All reminders should have the specified hours and minutes
      for (var reminder in result) {
        expect(reminder.date.isAfter(testDate), true);
        expect(reminder.date.hour, 15);
        expect(reminder.date.minute, 0);
      }

      // Verify that each reminder is scheduled at least one month apart
      // Note: We can't always expect a perfect month-to-month sequence due to
      // day existence issues in different months, but they should be properly spaced
      result.sort((a, b) => a.date.compareTo(b.date));
      for (int i = 1; i < result.length; i++) {
        final prevDate = result[i - 1].date;
        final currDate = result[i].date;

        // The difference should be at least 25 days (accounting for month transitions)
        final dayDiff = currDate.difference(prevDate).inDays;
        expect(dayDiff >= 25, true,
            reason:
                'Expected at least 25 days between reminders, got $dayDiff days');
      }
    });
  }

  void testLastDayOfMonthReminders(DateTime testDate) {
    testWithClock(
        'last day of month reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyMonthly(),
          dayOfMonth: LastDayOfMonth(),
          timeOfTheDay: const TimeOfDay(hour: 15, minute: 0),
        ),
        content: const ReminderContent(
            title: 'Monthly Reminder', body: 'This is a monthly reminder'),
      );

      int limit = 4;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // Test that all dates are the last day of their respective months
      for (var reminder in result) {
        expect(reminder.date.isAfter(testDate), true);

        // Calculate the last day of the reminder's month
        final nextMonth =
            reminder.date.month + 1 > 12 ? 1 : reminder.date.month + 1;
        final year = reminder.date.month + 1 > 12
            ? reminder.date.year + 1
            : reminder.date.year;
        final lastDayOfMonth = DateTime(year, nextMonth, 0).day;

        expect(reminder.date.day, lastDayOfMonth,
            reason:
                '${reminder.date} should be the last day of month ${reminder.date.month}');
        expect(reminder.date.hour, 15);
        expect(reminder.date.minute, 0);
      }
    });
  }

  void testQuarterlyReminders(DateTime testDate) {
    testWithClock(
        'quarterly reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyEveryThreeMonths(),
          dayOfMonth: DayOfMonthNumber(testDate.day),
          timeOfTheDay: const TimeOfDay(hour: 15, minute: 0),
        ),
        content: const ReminderContent(
            title: 'Quarterly Reminder', body: 'This is a quarterly reminder'),
      );

      int limit = 4;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // All reminders should have the specified hours and minutes
      for (var reminder in result) {
        expect(reminder.date.isAfter(testDate), true);
        expect(reminder.date.hour, 15);
        expect(reminder.date.minute, 0);
      }

      // Check that months are approximately 3 months apart
      result.sort((a, b) => a.date.compareTo(b.date));
      for (int i = 1; i < result.length; i++) {
        final previousMonth = result[i - 1].date.month;
        final currentMonth = result[i].date.month;

        // Check if months are approximately 3 apart (allowing for year boundaries)
        final diff = (currentMonth - previousMonth + 12) % 12;
        expect(diff == 3 || diff == 2 || diff == 4, true,
            reason:
                'Months should be approximately 3 months apart, got $diff between $previousMonth and $currentMonth');
      }
    });
  }

  void testQuarterlyLastDayReminders(DateTime testDate) {
    testWithClock(
        'quarterly last day reminder on ${testDate.year}-${testDate.month}-${testDate.day}',
        Clock.fixed(testDate), () {
      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyEveryThreeMonths(),
          dayOfMonth: LastDayOfMonth(),
          timeOfTheDay: const TimeOfDay(hour: 15, minute: 0),
        ),
        content: const ReminderContent(
            title: 'Quarterly Reminder', body: 'This is a quarterly reminder'),
      );

      int limit = 4;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // Test that all dates are the last day of their respective months
      for (var reminder in result) {
        expect(reminder.date.isAfter(testDate), true);

        // Calculate the last day of the given month
        final nextMonth =
            reminder.date.month + 1 > 12 ? 1 : reminder.date.month + 1;
        final year = reminder.date.month + 1 > 12
            ? reminder.date.year + 1
            : reminder.date.year;
        final lastDayOfMonth = DateTime(year, nextMonth, 0).day;

        expect(reminder.date.day, lastDayOfMonth,
            reason:
                '${reminder.date} should be the last day of month ${reminder.date.month}');
        expect(reminder.date.hour, 15);
        expect(reminder.date.minute, 0);
      }

      // Check that months are approximately 3 months apart
      result.sort((a, b) => a.date.compareTo(b.date));
      for (int i = 1; i < result.length; i++) {
        final previousMonth = result[i - 1].date.month;
        final currentMonth = result[i].date.month;

        // Check if months are approximately 3 apart (allowing for year boundaries)
        final diff = (currentMonth - previousMonth + 12) % 12;
        expect(diff == 3 || diff == 2 || diff == 4, true,
            reason:
                'Months should be approximately 3 months apart, got $diff between $previousMonth and $currentMonth');
      }
    });
  }

  group('RemindersScheduler', () {
    group('Dynamic date testing', () {
      // Run all test functions with all test dates
      for (final date in testDates) {
        testDailyReminders(date);
        testWeeklyReminders(date);
        testMonthlyReminders(date);
        testLastDayOfMonthReminders(date);
        testQuarterlyReminders(date);
        testQuarterlyLastDayReminders(date);
      }
    });

    // Additional tests for special cases or functionality that doesn't depend on date
    group('Special cases', () {
      testWithClock('generateScheduling with contentForIndex parameter',
          Clock.fixed(testDates.first), () {
        const reminderId = 'test';
        const scheduleTimeOfDay = TimeOfDay(hour: 15, minute: 0);

        const settings = ReminderSettings(
          time: DailyReminderTime(
            timeOfTheDay: scheduleTimeOfDay,
          ),
          content: ReminderContent(
              title: 'Default Reminder', body: 'This is a default reminder'),
        );

        ReminderContent contentForIndex(int index) {
          return ReminderContent(
            title: 'Custom Reminder $index',
            body: 'This is a custom reminder for index $index',
          );
        }

        int limit = 5;
        final result = RemindersScheduler.generateScheduling(
          reminderId,
          settings: settings,
          limit: limit,
          contentForIndex: contentForIndex,
        );

        expect(result.length, limit);

        // Verify the content is customized for each index
        for (int i = 0; i < result.length; i++) {
          expect(result[i].content.title, 'Custom Reminder $i');
          expect(
              result[i].content.body, 'This is a custom reminder for index $i');
        }
      });

      testWithClock(
          'generateScheduling with no settings', Clock.fixed(testDates[4]), () {
        const reminderId = 'test';
        final result = RemindersScheduler.generateScheduling(
          reminderId,
          settings: null,
          contentForIndex: (_) =>
              const ReminderContent(title: 'Test', body: 'Test'),
        );

        expect(result.length, 0);
      });
    });
  });
}

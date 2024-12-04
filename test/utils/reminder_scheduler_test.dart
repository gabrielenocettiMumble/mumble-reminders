import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:va_reminders/model/reminder_settings/reminder_content.dart';
import 'package:va_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:va_reminders/model/reminder_to_schedule.dart';
import 'package:va_reminders/utilities/reminders_scheduler.dart';

void main() {
  int getDaysLenghtOfMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  group('RemindersScheduler', () {
    test('generateScheduling with no settings', () async {
      const reminderId = 'test';
      final result = RemindersScheduler.generateScheduling(
        reminderId,
        settings: null,
      );

      expect(result.length, 0);
    });

    test('generateScheduling with daily reminder with time after current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(minutes: 5));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: DailyReminderTime(
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Daily Reminder', body: 'This is a daily reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // starts from -1 because the first reminder is scheduled for the current day
      int dayDifference = -1;
      for (var reminder in result) {
        dayDifference++;
        // check if the reminder is scheduled for the next day
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.day,
            currentDate.add(Duration(days: dayDifference)).day);

        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Daily Reminder');
        expect(reminder.body, 'This is a daily reminder');
      }
      // check if the reminders are not scheduled for the last day + 1

      // find reminder with the latest date
      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      // get the date of the limit + 1 days from now
      DateTime lastDate = currentDate.add(Duration(days: limit + 1));
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test('generateScheduling with daily reminder with time before current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.subtract(const Duration(minutes: 5));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: DailyReminderTime(
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Daily Reminder', body: 'This is a daily reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // starts from 0 because the first reminder is scheduled for the next day
      int dayDifference = 0;
      for (var reminder in result) {
        dayDifference++;
        // check if the reminder is scheduled for the next day
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.day,
            currentDate.add(Duration(days: dayDifference)).day);
        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Daily Reminder');
        expect(reminder.body, 'This is a daily reminder');
      }
      // check if the reminders are not scheduled for the last day + 2

      // find reminder with the latest date
      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      // get the date of the limit + 2 days from now
      DateTime lastDate = currentDate.add(Duration(days: limit + 2));
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test('generateScheduling with weekly reminder with time after current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(minutes: 5));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: WeeklyReminderTime(
          dayOfWeek: scheduleDate.weekday % 7,
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Weekly Reminder', body: 'This is a weekly reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // starts from 0 because the first reminder is scheduled for the current week
      int weekDifference = -1;
      for (var reminder in result) {
        weekDifference++;
        // check if the reminder is scheduled for the next week
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.weekday, currentDate.weekday);
        expect(reminder.date.day,
            currentDate.add(Duration(days: weekDifference * 7)).day);
        expect(reminder.date.toUtc().hour, scheduleDate.toUtc().hour);
        expect(reminder.date.toUtc().minute, scheduleDate.toUtc().minute);
        expect(reminder.title, 'Weekly Reminder');
        expect(reminder.body, 'This is a weekly reminder');
      }
      // check if the reminders are not scheduled for the last week + 1

      // find reminder with the latest date
      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      // get the date of the limit + 1 weeks from now
      DateTime lastDate = currentDate.add(Duration(days: (limit + 1) * 7));
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test('generateScheduling with weekly reminder with time before current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.subtract(const Duration(days: 1));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: WeeklyReminderTime(
          dayOfWeek: scheduleDate.weekday % 7,
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Weekly Reminder', body: 'This is a weekly reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // starts from 0 because the first reminder is scheduled for the next week
      int weekDifference = 0;
      for (var reminder in result) {
        weekDifference++;
        // check if the reminder is scheduled for the next week
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.weekday, scheduleDate.weekday);
        expect(reminder.date.day,
            scheduleDate.add(Duration(days: weekDifference * 7)).day);
        expect(reminder.date.toUtc().hour, scheduleDate.toUtc().hour);
        expect(reminder.date.toUtc().minute, scheduleDate.toUtc().minute);
        expect(reminder.title, 'Weekly Reminder');
        expect(reminder.body, 'This is a weekly reminder');
      }
      // check if the reminders are not scheduled for the last week + 2

      // find reminder with the latest date
      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      // get the date of the limit + 2 weeks from now
      DateTime lastDate = currentDate.add(Duration(days: (limit + 2) * 7));
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with monthly reminder with day of month after current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(days: 7));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyMonthly(),
          dayOfMonth: DayOfMonthNumber(scheduleDate.day),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Monthly Reminder', body: 'This is a monthly reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      int monthDifference = -1;
      for (var reminder in result) {
        monthDifference++;
        expect(reminder.date.isAfter(currentDate), true);
        int expectedYear = currentDate
            .copyWith(month: currentDate.month + monthDifference)
            .year;
        int expectedMonth = (currentDate.month + monthDifference) % 12;
        int daysInMonth = getDaysLenghtOfMonth(expectedMonth, expectedYear);
        if (scheduleDate.day > daysInMonth) {
          //TODO expect a different day and month
        } else {
          expect(reminder.date.day, scheduleDate.day);
          expect(reminder.date.isAfter(currentDate), true);
        }

        expect(
            reminder.date.month,
            scheduleDate
                .copyWith(month: currentDate.month + monthDifference)
                .month);
        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Monthly Reminder');
        expect(reminder.body, 'This is a monthly reminder');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          currentDate.copyWith(month: currentDate.month + limit);
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with monthly reminder with day of month before current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.subtract(const Duration(days: 7));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyMonthly(),
          dayOfMonth: DayOfMonthNumber(scheduleDate.day),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Monthly Reminder', body: 'This is a monthly reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      int monthDifference = (scheduleDate.month - currentDate.month);
      for (var reminder in result) {
        monthDifference++;
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.day, scheduleDate.day);
        expect(
            reminder.date.month,
            scheduleDate
                .copyWith(month: currentDate.month + monthDifference)
                .month);
        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Monthly Reminder');
        expect(reminder.body, 'This is a monthly reminder');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          currentDate.copyWith(month: currentDate.month + limit);
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with monthly reminder on the last day of the month',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(minutes: 5));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyMonthly(),
          dayOfMonth: LastDayOfMonth(),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Monthly Reminder', body: 'This is a monthly reminder'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      int monthDifference = -1;
      for (var reminder in result) {
        monthDifference++;
        expect(reminder.date.isAfter(currentDate), true);

        DateTime lastDayOfMonth = DateTime(
            currentDate.year, currentDate.month + monthDifference + 1, 0);

        expect(reminder.date.year, lastDayOfMonth.year);
        expect(reminder.date.month, lastDayOfMonth.month);
        expect(reminder.date.day, lastDayOfMonth.day);

        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Monthly Reminder');
        expect(reminder.body, 'This is a monthly reminder');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          DateTime(currentDate.year, currentDate.month + limit + 1, 0);
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with every three months reminder with day of month after current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(days: 7));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyEveryThreeMonths(),
          dayOfMonth: DayOfMonthNumber(scheduleDate.day),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Every Three Months Reminder',
            body: 'This is a reminder every three months'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      int monthDifference = -3;
      for (var reminder in result) {
        monthDifference += 3;
        expect(reminder.date.isAfter(currentDate), true);
        int expectedYear = currentDate
            .copyWith(month: currentDate.month + monthDifference)
            .year;
        int expectedMonth = (currentDate.month + monthDifference) % 12;
        int daysInMonth = getDaysLenghtOfMonth(expectedMonth, expectedYear);
        if (scheduleDate.day > daysInMonth) {
          //TODO expect a different day and month
        } else {
          expect(reminder.date.day, scheduleDate.day);
          expect(reminder.date.isAfter(currentDate), true);
        }
        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Every Three Months Reminder');
        expect(reminder.body, 'This is a reminder every three months');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          currentDate.copyWith(month: currentDate.month + limit * 3);
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with every three months reminder with day of month before current',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.subtract(const Duration(days: 7));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyEveryThreeMonths(),
          dayOfMonth: DayOfMonthNumber(scheduleDate.day),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Every Three Months Reminder',
            body: 'This is a reminder every three months'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      // starts from -2 because the first reminder is scheduled for the next month
      int monthDifference = (scheduleDate.month - currentDate.month) * 3;
      for (var reminder in result) {
        monthDifference += 3;
        expect(reminder.date.isAfter(currentDate), true);
        expect(reminder.date.day, scheduleDate.day);
        expect(
            reminder.date.month,
            scheduleDate
                .copyWith(month: currentDate.month + monthDifference)
                .month);
        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Every Three Months Reminder');
        expect(reminder.body, 'This is a reminder every three months');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          currentDate.copyWith(month: currentDate.month + limit * 3);
      expect(lastReminder.date.isBefore(lastDate), true);
    });

    test(
        'generateScheduling with every three months reminder on the last day of the month',
        () async {
      final currentDate = DateTime.now();
      final scheduleDate = currentDate.add(const Duration(minutes: 5));

      const reminderId = 'test';
      final settings = ReminderSettings(
        time: MonthlyReminderTime(
          frequency: const ReminderFrequencyEveryThreeMonths(),
          dayOfMonth: LastDayOfMonth(),
          timeOfTheDay: TimeOfDay.fromDateTime(scheduleDate),
        ),
        content: const ReminderContent(
            title: 'Every Three Months Reminder',
            body: 'This is a reminder every three months'),
      );

      int limit = 64;
      final result = RemindersScheduler.generateScheduling(reminderId,
          settings: settings, limit: limit);

      expect(result.length, limit);

      int monthDifference = -3;
      for (var reminder in result) {
        monthDifference += 3;
        expect(reminder.date.isAfter(currentDate), true);

        DateTime lastDayOfMonth = DateTime(
            currentDate.year, currentDate.month + monthDifference + 1, 0);

        expect(reminder.date.year, lastDayOfMonth.year);
        expect(reminder.date.month, lastDayOfMonth.month);
        expect(reminder.date.day, lastDayOfMonth.day);

        expect(reminder.date.hour, scheduleDate.hour);
        expect(reminder.date.minute, scheduleDate.minute);
        expect(reminder.title, 'Every Three Months Reminder');
        expect(reminder.body, 'This is a reminder every three months');
      }

      result.sort((a, b) => a.date.compareTo(b.date));
      ReminderToSchedule lastReminder = result.last;
      DateTime lastDate =
          DateTime(currentDate.year, currentDate.month + limit * 3 + 1, 0);
      expect(lastReminder.date.isBefore(lastDate), true);
    });
  });
}

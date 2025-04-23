import 'package:mumble_reminders/model/reminder_settings/reminder_content.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_to_schedule.dart';

class RemindersScheduler {
  static List<ReminderToSchedule> generateScheduling(
    String reminderId, {
    int limit = 64,
    required ReminderSettings? settings,
  }) {
    if (settings != null) {
      List<DateTime> dates = _generateDates(settings, limit);
      return [
        for (var date in dates)
          ReminderToSchedule(
            reminderId: reminderId,
            date: date,
            content: ReminderContent(
              title: settings.content.title,
              body: settings.content.body,
            ),
          )
      ];
    }
    return [];
  }

  static List<DateTime> _generateDates(ReminderSettings settings, int limit) {
    switch (settings.time.frequency) {
      case ReminderFrequencyDaily():
        return _generateDailyDates(settings.time as DailyReminderTime, limit);
      case ReminderFrequencyWeekly():
        return _generateWeeklyDates(settings.time as WeeklyReminderTime, limit);
      case ReminderFrequencyMonthly():
      case ReminderFrequencyEveryThreeMonths():
        return _generateMonthlyDates(
          settings.time as MonthlyReminderTime,
          limit,
          monthIncrement: settings.time.frequency ==
                  const ReminderFrequencyEveryThreeMonths()
              ? 3
              : 1,
        );
    }
  }

  static DateTime _getStartDate(DateTime now, int hour, int minute) {
    DateTime startDate = now.copyWith(
        hour: hour, minute: minute, second: 0, millisecond: 0, microsecond: 0);
    return startDate.isBefore(now)
        ? startDate.add(const Duration(days: 1))
        : startDate;
  }

  static List<DateTime> _generateDailyDates(
      DailyReminderTime settings, int limit) {
    DateTime startDate = _getStartDate(DateTime.now(),
        settings.timeOfTheDay.hour, settings.timeOfTheDay.minute);
    return List.generate(limit, (i) => startDate.add(Duration(days: i)));
  }

  static List<DateTime> _generateWeeklyDates(
      WeeklyReminderTime settings, int limit) {
    DateTime startDate = _getStartDate(DateTime.now(),
        settings.timeOfTheDay.hour, settings.timeOfTheDay.minute);
    while ((startDate.weekday - 1) != settings.dayOfWeek) {
      startDate = startDate.add(const Duration(days: 1));
    }
    startDate = startDate.subtract(const Duration(days: 1));
    return List.generate(limit, (i) => startDate.add(Duration(days: i * 7)));
  }

  static List<DateTime> _generateMonthlyDates(
      MonthlyReminderTime settings, int limit,
      {int monthIncrement = 1}) {
    DateTime now = DateTime.now();

    // Generate the start date (it sets the time of the day)
    DateTime startDate = _getStartDate(
        now, settings.timeOfTheDay.hour, settings.timeOfTheDay.minute);

    // Set the day of the month
    switch (settings.dayOfMonth) {
      case DayOfMonthNumber(day: final dayOfMonth):
        // Set the day of the month, go to the next month if needed
        while (startDate.day != dayOfMonth) {
          startDate = startDate.add(const Duration(days: 1));
        }

        return List.generate(
          limit,
          (i) => DateTime(
            startDate.year,
            i * monthIncrement + startDate.month,
            startDate.day,
            settings.timeOfTheDay.hour,
            settings.timeOfTheDay.minute,
          ),
        );

      case LastDayOfMonth(lastDayOfTheMonth: final lastDayOfTheMonth):
        return List.generate(
          limit,
          (i) {
            DateTime lastDay = lastDayOfTheMonth(
                startDate.year, startDate.month + i * monthIncrement);
            return DateTime(
              lastDay.year,
              lastDay.month,
              lastDay.day,
              settings.timeOfTheDay.hour,
              settings.timeOfTheDay.minute,
            );
          },
        );
    }
  }
}

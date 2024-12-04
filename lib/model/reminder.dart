import 'package:va_reminders/model/reminder_settings/reminder_content.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_time.dart';
//TODO think about how to separate the manager to the defined things on the app
class Reminder {
  String id;
  Set<ReminderFrequency> frequencies;
  ReminderContent defaultContent;
  ReminderTime defaultReminderTime;

  Reminder({
    required this.id,
    required this.frequencies,
    required this.defaultContent,
    required this.defaultReminderTime,
  });

  ///Factory method that creates a Reminder object with all the available frequencies.
  factory Reminder.allFrequencies({
    required String id,
    required bool lastDayOfTheMonthEnabled,
    required ReminderContent defaultContent,
    required ReminderTime defaultReminderTime,
  }) {
    return Reminder(
      id: id,
      frequencies: {
        const ReminderFrequencyDaily(),
        const ReminderFrequencyWeekly(),
        ReminderFrequencyMonthly(
            lastDayOfTheMonthEnabled: lastDayOfTheMonthEnabled),
        ReminderFrequencyEveryThreeMonths(
            lastDayOfTheMonthEnabled: lastDayOfTheMonthEnabled),
      },
      defaultContent: defaultContent,
      defaultReminderTime: defaultReminderTime,
    );
  }
}

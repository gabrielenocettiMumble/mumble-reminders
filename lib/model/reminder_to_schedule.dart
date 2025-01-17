import 'package:va_reminders/model/reminder_settings/reminder_content.dart';

class ReminderToSchedule {
  final String reminderId;
  final DateTime date;
  final ReminderContent content;

  const ReminderToSchedule({
    required this.reminderId,
    required this.date,
    required this.content,
  });
}

import 'package:va_reminders/manager/reminders_manager.dart';
import 'package:va_reminders/model/reminder_manager_options.dart';

class Providers {
  static RemindersManager remindersManager = RemindersManager(
    options: ReminderManagerOptions(
      androidOptions: AndroidReminderManagerOptions(
        androidChannelId: 'example_channel_id',
        androidChannelName: 'example_channel_name',
        defaultDrawableIcon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

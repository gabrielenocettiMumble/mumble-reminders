import 'package:mumble_reminders/manager/reminders_manager.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';

class Providers {
  static RemindersManager remindersManager = RemindersManager(
    options: ReminderManagerOptions(
      androidOptions: AndroidReminderManagerOptions(
        androidChannelId: 'example_channel_id',
        androidChannelName: 'Example Reminders',
        androidChannelDescription: 'Channel for example reminder notifications',
        defaultDrawableIcon: '@mipmap/ic_launcher',
      ),
    ),
  );
}

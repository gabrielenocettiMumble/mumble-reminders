import 'dart:developer';

import 'package:mumble_reminders/manager/reminders_manager.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';

class ReminderProvider extends RemindersManager {
  ReminderProvider()
      : super(
          options: ReminderManagerOptions(
            androidOptions: AndroidReminderManagerOptions(
              androidChannelId: 'example_channel_id',
              androidChannelName: 'example_channel_name',
              defaultDrawableIcon: '@mipmap/ic_launcher',
            ),
          ),
          navigationCallback: (payload) {
            log('Notification clicked with payload: $payload');
          },
        );
}

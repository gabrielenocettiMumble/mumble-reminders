import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mumble_reminders/database/reminders_db_manager.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:mumble_reminders/model/reminder_to_schedule.dart';
import 'package:mumble_reminders/utilities/local_notification_utility.dart';
import 'package:mumble_reminders/utilities/reminders_scheduler.dart';

//TODO READ IT, the objective of this package is to avoid the dependency of flutterLocalNotification and the db access from the app
// all the others features like navigation callback are app side
class RemindersManager extends ChangeNotifier {
  final ReminderManagerOptions options;

  FlutterLocalNotificationsPlugin? _plugin;

  // Function called by the reminders manager, that needs to be set in the main
  // to navigate to the correct view. The String parameter is the route to navigate
  //TODO find a way to set in the main this and also the timezone in one callback only
  Function(String payload)? navigationCallback;

  RemindersManager({required this.options, this.navigationCallback}) {
    _loadReminderSettings();
    initializePlugin();
  }

  Future<void> initializePlugin() async {
    _plugin = await LocalNotificationUtility.notificationsPlugin(
        openNotification: _openNotification,
        defaultDrawableIcon: options.androidOptions.defaultDrawableIcon);
  }

  void _openNotification(String? payload) {
    if (navigationCallback != null && payload != null) {
      navigationCallback!(payload);
    }
  }

  final Map<String, ReminderSettings?> _reminderSettings = {};

  Future<void> _loadReminderSettings() async {
    List<String> ids = await RemindersDbManager.getIds();
    await Future.wait(ids.map((id) async {
      _reminderSettings[id] =
          await RemindersDbManager.settingsForReminderID(id);
    }));
    notifyListeners();
  }

  Future<void> updateReminderSettings(
      String id, ReminderSettings settings) async {
    _reminderSettings[id] = settings;
    notifyListeners();
    await RemindersDbManager.setSettingsForReminderID(id, settings);
    await _updateScheduledReminders();
  }

  Future<void> removeReminderSettings(String id) async {
    _reminderSettings.remove(id);
    notifyListeners();
    await RemindersDbManager.removeSettingsForReminderID(id);
    await _updateScheduledReminders();
  }

  Future<void> clearAllReminderSettings() async {
    _reminderSettings.clear();
    notifyListeners();
    await RemindersDbManager.toEmptyTable();
  }

  ReminderSettings? getReminderSettings(String id) => _reminderSettings[id];

  Future<void> _updateScheduledReminders() async {
    bool permission = false;
    try {
      permission = await LocalNotificationUtility.askPermissions();
    } on NotificationPermissionDeniedException {
      rethrow;
    }
    if (!permission) return;

    List<ReminderToSchedule> reminders = [];

    for (String reminderId in _reminderSettings.keys) {
      reminders.addAll(
        RemindersScheduler.generateScheduling(
          reminderId,
          settings: _reminderSettings[reminderId]!,
        ),
      );
    }

    await Future.wait(
      [
        for (var reminder in reminders)
          LocalNotificationUtility.scheduleNotification(_plugin!, reminder,
              options: options)
      ],
    );
  }
}

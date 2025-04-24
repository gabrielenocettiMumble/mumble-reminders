import 'package:flutter/foundation.dart';
import 'package:mumble_reminders/database/reminders_db_manager.dart';
import 'package:mumble_reminders/manager/notification_plugin.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_content.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:mumble_reminders/model/reminder_to_schedule.dart';
import 'package:mumble_reminders/utilities/reminders_scheduler.dart';

typedef ReminderContentForIndex = ReminderContent Function(int index);

abstract class RemindersManager extends ChangeNotifier {
  final ReminderManagerOptions options;

  late final NotificationPlugin _plugin = NotificationPlugin(
    defaultDrawableIcon: options.androidOptions.defaultDrawableIcon,
    onReceiveNotification: _openNotification,
  );

  Function(String payload)? navigationCallback;

  RemindersManager({required this.options, this.navigationCallback}) {
    _loadReminderSettings().then((_) {
      initializePlugin();
    });
  }

  Future<void> initializePlugin() async {
    await _plugin.init();

    _updateScheduledReminders();
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

  Future<void> updateReminderSettings(String id, ReminderSettings settings,
      {ReminderContentForIndex? contentForIndex}) async {
    //TODO find a way to avoid cancelling all the notifications with different content for index every time _updateScheduledReminders is called
    contentForIndex = null;
    _reminderSettings[id] = settings;
    notifyListeners();
    await RemindersDbManager.setSettingsForReminderID(id, settings);
    try {
      await _updateScheduledReminders(id: id, cForIndex: contentForIndex);
    } on NotificationPermissionException {
      await removeReminderSettings(id);
    }
  }

  Future<void> removeReminderSettings(String id) async {
    _reminderSettings.remove(id);
    notifyListeners();
    await RemindersDbManager.removeSettingsForReminderID(id);
    await _updateScheduledReminders(id: id);
  }

  Future<void> clearAllReminderSettings() async {
    _reminderSettings.clear();
    notifyListeners();
    await RemindersDbManager.toEmptyTable();
  }

  ReminderSettings? getReminderSettings(String id) => _reminderSettings[id];

  Future<void> _updateScheduledReminders(
      {String? id, ReminderContentForIndex? cForIndex}) async {
    if (_reminderSettings.isEmpty) return;
    try {
      await _plugin.askPermissions(options.androidOptions.useExactAlarm);
    } on NotificationPermissionException {
      rethrow;
    }

    List<ReminderToSchedule> reminders = [];

    await _plugin.cancelAll();

    for (String reminderId in _reminderSettings.keys) {
      reminders.addAll(
        RemindersScheduler.generateScheduling(
          reminderId,
          settings: _reminderSettings[reminderId],
          // use the id and cForIndex to schedule the reminder with different content if needed
          contentForIndex: id == reminderId ? cForIndex : null,
        ),
      );
    }

    await Future.wait(
      [
        for (var reminder in reminders)
          _plugin.scheduleNotification(reminder, options: options)
      ],
    );
  }
}

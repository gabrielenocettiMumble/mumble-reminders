import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mumble_reminders/database/reminders_db_manager.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';
import 'package:mumble_reminders/model/reminder_to_schedule.dart';
import 'package:mumble_reminders/utilities/reminders_scheduler.dart';
import 'package:mumble_reminders/utilities/reminders_shared_prefrences_utility.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Notification utility used to interact with the local notifications plugin
class LocalNotificationUtility {
  //TODO remember to call this function in the main
  static void initializeTimeZones() => tz.initializeTimeZones();

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static Future<FlutterLocalNotificationsPlugin> notificationsPlugin({
    String defaultDrawableIcon = '@drawable/ic_notification',
    required Function(String)? openNotification,
  }) async {
    if (_flutterLocalNotificationsPlugin != null) {
      return _flutterLocalNotificationsPlugin!;
    }
    await _initNotificationsPlugin(defaultDrawableIcon, openNotification!);
    return _flutterLocalNotificationsPlugin!;
  }

  static Future<void> _initNotificationsPlugin(
    String defaultDrawableIcon,
    Function(String) onReceiveNotification,
  ) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(defaultDrawableIcon);

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) onReceiveNotification(response.payload!);
      },
    );

    _flutterLocalNotificationsPlugin = plugin;
  }

  /// throws [NotificationPermissionDeniedException] if the user denies the permission
  ///
  /// throws [ScheduleExactAlarmPermissionDeniedException] if the user denies the permission to schedule exact alarms (Android only)
  static Future<bool> askPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!;

      bool permission =
          await androidPlugin.requestNotificationsPermission() ?? false;
      if (!permission) throw NotificationPermissionDeniedException();
      bool exactAlarmPermission = true;
      if (await androidPlugin.canScheduleExactNotifications() != true) {
        exactAlarmPermission =
            await androidPlugin.requestExactAlarmsPermission() ?? false;
        if (!exactAlarmPermission) {
          throw ScheduleExactAlarmPermissionDeniedException();
        }
      }

      await RemindersSharedPrefrencesUtility.setNotificationPermissionAsked();

      return permission && exactAlarmPermission;
    } else {
      bool permission = await FlutterLocalNotificationsPlugin()
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()!
              .requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
      if (!permission) throw NotificationPermissionDeniedException();

      await RemindersSharedPrefrencesUtility.setNotificationPermissionAsked();

      return permission;
    }
  }

  static Future<List<ReminderToSchedule>> scheduledRemindersToUpdate(
      List<String> allReminderIDs) async {
    List<ReminderToSchedule> reminders = [];

    List<String> reminderIds = await RemindersDbManager.getIds();

    for (String reminderId in allReminderIDs) {
      reminderIds = reminderIds..remove(reminderId);
      reminders.addAll(
        RemindersScheduler.generateScheduling(
          reminderId,
          settings: await RemindersDbManager.settingsForReminderID(reminderId),
        ),
      );
    }

    for (String id in reminderIds) {
      reminders.addAll(
        RemindersScheduler.generateScheduling(
          id,
          settings: await RemindersDbManager.settingsForReminderID(id),
        ),
      );
    }
    reminders.sort((r1, r2) => r1.date.compareTo(r2.date));

    return reminders;
  }

  static Future<void> scheduleNotification(
    FlutterLocalNotificationsPlugin notificationsPlugin,
    ReminderToSchedule reminder, {
    required ReminderManagerOptions options,
  }) async {
    if (reminder.date.isBefore(DateTime.now())) {
      return;
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      options.androidOptions.androidChannelId,
      options.androidOptions.androidChannelName,
      channelDescription: options.androidOptions.androidChannelDescription,
      playSound: true,
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    String? reminderTitle = reminder.content.title;

    String? reminderDescription = reminder.content.body;

    String reminderId = reminder.reminderId;

    Map<String, dynamic> notificationPayload = {
      'reminder_id': reminderId,
    };

    int uinqueId = reminderId.hashCode ^
        DateTime.now().millisecondsSinceEpoch.toString().hashCode;

    await notificationsPlugin.zonedSchedule(
      uinqueId,
      reminderTitle,
      reminderDescription,
      tz.TZDateTime.from(reminder.date, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: json.encode(notificationPayload),
    );
  }
}

class NotificationPermissionException implements Exception {}

class NotificationPermissionDeniedException
    extends NotificationPermissionException {}

class ScheduleExactAlarmPermissionDeniedException
    extends NotificationPermissionException {}

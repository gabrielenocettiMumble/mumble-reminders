import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mumble_reminders/model/reminder_manager_options.dart';
import 'package:mumble_reminders/model/reminder_to_schedule.dart';
import 'package:mumble_reminders/utilities/reminders_shared_prefrences_utility.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin? _plugin;
  FlutterLocalNotificationsPlugin? get plugin => _plugin;
  String defaultDrawableIcon;
  Function(String)? onReceiveNotification;

  NotificationPlugin({
    this.defaultDrawableIcon = '@drawable/ic_notification',
    required this.onReceiveNotification,
  }) {
    tz.initializeTimeZones();
  }

  Future<void> init() async {
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
        if (response.payload != null && onReceiveNotification != null) {
          onReceiveNotification!(response.payload!);
        }
      },
    );

    _plugin = plugin;
  }

  /// throws [NotificationPermissionDeniedException] if the user denies the permission
  ///
  /// throws [ScheduleExactAlarmPermissionDeniedException] if the user denies the permission to schedule exact alarms (Android only)
  Future<bool> askPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!;

      bool permission =
          await androidPlugin.requestNotificationsPermission() ?? false;
      if (!permission) throw NotificationPermissionDeniedException();
      bool exactAlarmPermission = true;
      if (await androidPlugin.canScheduleExactNotifications() != true) {
        //TODO add chance to set or disable the exact alarm permission
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

  Future<void> scheduleNotification(
    ReminderToSchedule reminder, {
    required ReminderManagerOptions options,
  }) async {
    if (reminder.date.isBefore(DateTime.now())) {
      return;
    }

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      options.androidOptions.androidChannelId,
      options.androidOptions.androidChannelName,
      channelDescription: options.androidOptions.androidChannelDescription,
      playSound: true,
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
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

    await _plugin?.zonedSchedule(
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

  Future<void> cancelAll() => _plugin?.cancelAll() ?? Future.value();
}

class NotificationPermissionException implements Exception {}

class NotificationPermissionDeniedException
    extends NotificationPermissionException {}

class ScheduleExactAlarmPermissionDeniedException
    extends NotificationPermissionException {}

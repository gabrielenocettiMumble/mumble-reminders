import 'package:flutter/material.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/reminder_time.dart';
import 'reminder_content.dart';

class ReminderSettings {
  final ReminderTime time;
  final ReminderContent content;

  const ReminderSettings({
    required this.time,
    required this.content,
  });

  factory ReminderSettings.fromDbMap(Map<String, dynamic> map) {
    ReminderTime timeSettings = ReminderTime.fromDbMap(map);
    ReminderContent contentSettings = ReminderContent.fromDbMap(map);

    return ReminderSettings(
      time: timeSettings,
      content: contentSettings,
    );
  }

  Map<String, dynamic> toDbMap() => {...time.toDbMap(), ...content.toDbMap()};

  String getDescription(BuildContext context) => time.getDescription(context);
}

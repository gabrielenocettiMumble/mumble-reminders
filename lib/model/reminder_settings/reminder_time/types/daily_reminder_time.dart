import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_time.dart';
import 'package:mumble_reminders/utilities/time_utiils.dart';

class DailyReminderTime extends ReminderTime {
  const DailyReminderTime({
    required super.timeOfTheDay,
  }) : super(frequency: const ReminderFrequencyDaily());

  @override
  DailyReminderTime copyWith({
    TimeOfDay? timeOfTheDay,
  }) =>
      DailyReminderTime(timeOfTheDay: timeOfTheDay ?? this.timeOfTheDay);

  factory DailyReminderTime.fromDbMap(Map<String, dynamic> map) =>
      DailyReminderTime(timeOfTheDay: TimeUtils.fromDbTime(map['time']));

  @override
  String getDescription(BuildContext context) {
    String timeString = timeOfTheDay.format(context);
    return "Every day, at $timeString";
  }
}

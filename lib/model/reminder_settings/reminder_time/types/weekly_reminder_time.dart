import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_time.dart';

class WeeklyReminderTime extends ReminderTime {
  final int dayOfWeek;

  const WeeklyReminderTime({
    required super.timeOfTheDay,
    required this.dayOfWeek,
  }) : super(frequency: const ReminderFrequencyWeekly());

  @override
  WeeklyReminderTime copyWith({
    TimeOfDay? timeOfTheDay,
    int? dayOfWeek,
  }) {
    return WeeklyReminderTime(
      timeOfTheDay: timeOfTheDay ?? this.timeOfTheDay,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    );
  }

  factory WeeklyReminderTime.fromDbMap(Map<String, dynamic> map) =>
      WeeklyReminderTime(
        timeOfTheDay: DbMapMixin.timeOfDayFromDbMap(map),
        dayOfWeek: map['day_of_week'],
      );

  @override
  Map<String, dynamic> toDbMap() =>
      super.toDbMap()..addAll({'day_of_week': dayOfWeek});

  @override
  String getDescription(BuildContext context) {
    String timeString = timeOfTheDay.format(context);
    return "Every week on day $dayOfWeek, at $timeString";
  }
}

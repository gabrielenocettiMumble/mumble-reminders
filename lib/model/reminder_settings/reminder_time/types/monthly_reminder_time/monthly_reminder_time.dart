import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';

class MonthlyReminderTime extends ReminderTime {
  final DayOfMonth dayOfMonth;

  const MonthlyReminderTime({
    required super.frequency,
    required super.timeOfTheDay,
    required this.dayOfMonth,
  });

  @override
  MonthlyReminderTime copyWith({
    ReminderFrequency? frequency,
    TimeOfDay? timeOfTheDay,
    DayOfMonth? dayOfMonth,
  }) {
    return MonthlyReminderTime(
      frequency: frequency ?? this.frequency,
      timeOfTheDay: timeOfTheDay ?? this.timeOfTheDay,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
    );
  }

  factory MonthlyReminderTime.fromDbMap(Map<String, dynamic> map) {
    int? dayOfMonthNumber = map['day_of_month_number'];
    bool? lastDayOfTheMonth = (map['last_day_of_the_month'] ?? 0) == 1;

    DayOfMonth dayOfMonth =
        dayOfMonthNumber == null && lastDayOfTheMonth == true
            ? LastDayOfMonth()
            : (dayOfMonthNumber != null
                ? DayOfMonthNumber(dayOfMonthNumber)
                : throw Exception('Invalid day of month'));

    return MonthlyReminderTime(
      frequency: DbMapMixin.frequencyFromDbMap(map),
      timeOfTheDay: DbMapMixin.timeOfDayFromDbMap(map),
      dayOfMonth: dayOfMonth,
    );
  }

  @override
  Map<String, dynamic> toDbMap() => super.toDbMap()
    ..addAll(
      switch (dayOfMonth) {
        LastDayOfMonth() => {'last_day_of_the_month': 1},
        DayOfMonthNumber(day: final dayOfMonth) => {
            'day_of_month_number': dayOfMonth,
          },
      },
    );

  @override
  String getDescription(BuildContext context) {
    String timeString = timeOfTheDay.format(context);
    return switch (dayOfMonth) {
      LastDayOfMonth() => "Every month on the last day, at $timeString",
      DayOfMonthNumber() =>
        "Every month on day ${(dayOfMonth as DayOfMonthNumber).day}, at $timeString",
    };
  }
}

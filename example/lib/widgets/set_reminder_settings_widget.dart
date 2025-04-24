import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_content.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/weekly_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/monthly_reminder_time.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';

import 'day_of_month_picker.dart';
import 'day_of_week_picker.dart';
import 'reminder_content_form.dart';
import 'reminder_type_picker.dart';
import 'time_of_day_picker.dart';

class SetReminderSettingsWidget extends StatefulWidget {
  const SetReminderSettingsWidget({
    super.key,
    required this.onReminderSettingsChanged,
    required this.reminderSettings,
  });

  final ReminderSettings? reminderSettings;
  final Function(ReminderSettings) onReminderSettingsChanged;

  @override
  State<SetReminderSettingsWidget> createState() =>
      _SetReminderSettingsWidgetState();
}

class _SetReminderSettingsWidgetState extends State<SetReminderSettingsWidget> {
  late ReminderSettings? reminderSettings = widget.reminderSettings;

  late TextEditingController titleController =
      TextEditingController(text: reminderSettings?.content.title);
  late TextEditingController bodyController =
      TextEditingController(text: reminderSettings?.content.body);

  late ValueNotifier<TimeOfDay?> timeOfDayNotifier =
      ValueNotifier<TimeOfDay?>(reminderSettings?.time.timeOfTheDay);

  late final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  ReminderFrequency _selectedFrequency = const ReminderFrequencyDaily();
  int _selectedDayOfWeek = 1; // Monday
  int _selectedDayOfMonth = 1;
  bool _useLastDayOfMonth = false;

  @override
  void initState() {
    super.initState();

    // Set up listeners for form validation
    timeOfDayNotifier.addListener(_validateForm);
    titleController.addListener(_validateForm);
    bodyController.addListener(_validateForm);

    if (reminderSettings != null) {
      _selectedFrequency = reminderSettings!.time.frequency;

      // Initialize day of week if it's a weekly reminder
      if (reminderSettings!.time is WeeklyReminderTime) {
        _selectedDayOfWeek =
            (reminderSettings!.time as WeeklyReminderTime).dayOfWeek;
      }

      // Initialize day of month if it's a monthly reminder
      if (reminderSettings!.time is MonthlyReminderTime) {
        final monthlyTime = reminderSettings!.time as MonthlyReminderTime;
        if (monthlyTime.dayOfMonth is LastDayOfMonth) {
          _useLastDayOfMonth = true;
        } else if (monthlyTime.dayOfMonth is DayOfMonthNumber) {
          _selectedDayOfMonth =
              (monthlyTime.dayOfMonth as DayOfMonthNumber).day;
        }
      }
    }

    // Initial validation
    _validateForm();
  }

  @override
  void dispose() {
    timeOfDayNotifier.removeListener(_validateForm);
    titleController.removeListener(_validateForm);
    bodyController.removeListener(_validateForm);
    _isFormValid.dispose();
    super.dispose();
  }

  void _validateForm() {
    _isFormValid.value = content != null && timeOfDayNotifier.value != null;
  }

  ReminderContent? get content {
    if (titleController.text.trim().isEmpty &&
        bodyController.text.trim().isEmpty) {
      return null;
    } else {
      return ReminderContent(
        title: titleController.text,
        body: bodyController.text,
      );
    }
  }

  ReminderSettings? get settings {
    if (content == null || timeOfDayNotifier.value == null) {
      return null;
    }

    switch (_selectedFrequency) {
      case ReminderFrequencyDaily():
        return ReminderSettings(
          content: content!,
          time: DailyReminderTime(timeOfTheDay: timeOfDayNotifier.value!),
        );

      case ReminderFrequencyWeekly():
        return ReminderSettings(
          content: content!,
          time: WeeklyReminderTime(
            timeOfTheDay: timeOfDayNotifier.value!,
            dayOfWeek: _selectedDayOfWeek,
          ),
        );

      case ReminderFrequencyMonthly():
      case ReminderFrequencyEveryThreeMonths():
        DayOfMonth dayOfMonth = _useLastDayOfMonth
            ? LastDayOfMonth()
            : DayOfMonthNumber(_selectedDayOfMonth);

        return ReminderSettings(
          content: content!,
          time: MonthlyReminderTime(
            frequency: _selectedFrequency,
            timeOfTheDay: timeOfDayNotifier.value!,
            dayOfMonth: dayOfMonth,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Create Reminder',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Reminder content
            ReminderContentForm(
              titleController: titleController,
              bodyController: bodyController,
              onChanged: _validateForm,
            ),
            const SizedBox(height: 24),

            // Reminder frequency selection
            ReminderTypePicker(
              selectedFrequency: _selectedFrequency,
              onFrequencyChanged: (frequency) {
                setState(() {
                  _selectedFrequency = frequency;
                });
              },
            ),
            const SizedBox(height: 24),

            // Show day picker for weekly reminders
            if (_selectedFrequency is ReminderFrequencyWeekly)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: DayOfWeekPicker(
                  selectedDay: _selectedDayOfWeek,
                  onDaySelected: (day) {
                    setState(() {
                      _selectedDayOfWeek = day;
                    });
                  },
                ),
              ),

            // Show day picker for monthly reminders
            if (_selectedFrequency is ReminderFrequencyMonthly ||
                _selectedFrequency is ReminderFrequencyEveryThreeMonths)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: DayOfMonthPicker(
                  selectedDay: _selectedDayOfMonth,
                  useLastDay: _useLastDayOfMonth,
                  onDaySelected: (day) {
                    setState(() {
                      _selectedDayOfMonth = day;
                    });
                  },
                  onUseLastDayChanged: (value) {
                    setState(() {
                      _useLastDayOfMonth = value;
                    });
                  },
                ),
              ),

            // Time of day selection
            TimeOfDayPicker(
              timeOfDayNotifier: timeOfDayNotifier,
              onChanged: _validateForm,
            ),
            const SizedBox(height: 24),

            // Save button
            ListenableBuilder(
              listenable: _isFormValid,
              builder: (context, _) {
                return Center(
                  child: ElevatedButton.icon(
                    onPressed: _isFormValid.value
                        ? () {
                            widget.onReminderSettingsChanged(settings!);
                          }
                        : null,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Reminder'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

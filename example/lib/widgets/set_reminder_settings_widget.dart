import 'package:flutter/material.dart';
import 'package:va_reminders/model/reminder_settings/reminder_content.dart';
import 'package:va_reminders/model/reminder_settings/reminder_settings.dart';
import 'package:va_reminders/model/reminder_settings/reminder_time/types/daily_reminder_time.dart';

class SetReminderSettingsWidget extends StatefulWidget {
  const SetReminderSettingsWidget(
      {super.key,
      required this.onReminderSettingsChanged,
      required this.reminderSettings});

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
    } else {
      return ReminderSettings(
        content: content!,
        time: DailyReminderTime(timeOfTheDay: timeOfDayNotifier.value!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // set title
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  return;
                }
              },
            ),

            // set body
            TextField(
              decoration: const InputDecoration(
                labelText: 'Body',
              ),
              controller: bodyController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  return;
                }
              },
            ),

            // set daily reminder time
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((timeOfDay) {
                      if (timeOfDay == null) {
                        return;
                      } else {
                        timeOfDayNotifier.value = timeOfDay;
                      }
                    });
                  },
                  child: const Text('Set Time'),
                ),

                // show current time
                ListenableBuilder(
                    listenable: timeOfDayNotifier,
                    builder: (context, _) {
                      return Text(
                        timeOfDayNotifier.value?.toString() ?? 'No time set',
                      );
                    }),
              ],
            ),

            // save reminder settings
            ElevatedButton(
              onPressed: () {
                if (settings == null) {
                  return;
                }
                widget.onReminderSettingsChanged(settings!);
              },
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

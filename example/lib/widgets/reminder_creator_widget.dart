import 'package:flutter/material.dart';
import 'package:mumble_reminders_example/providers/providers.dart';
import 'package:mumble_reminders_example/widgets/set_reminder_settings_widget.dart';
import 'package:uuid/uuid.dart';

class ReminderCreatorWidget extends StatefulWidget {
  const ReminderCreatorWidget({super.key});

  @override
  State<ReminderCreatorWidget> createState() => _ReminderCreatorWidgetState();
}

class _ReminderCreatorWidgetState extends State<ReminderCreatorWidget> {
  final TextEditingController _reminderIdController = TextEditingController();
  final uuid = const Uuid();
  bool _useCustomId = false;

  @override
  void initState() {
    super.initState();
    _generateRandomId();
  }

  void _generateRandomId() {
    _reminderIdController.text = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder ID section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Reminder ID',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: _useCustomId,
                    onChanged: (value) {
                      setState(() {
                        _useCustomId = value;
                        if (!value) {
                          _generateRandomId();
                        }
                      });
                    },
                  ),
                  const Text('Custom ID'),
                ],
              ),
            ),

            if (_useCustomId)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _reminderIdController,
                        decoration: const InputDecoration(
                          labelText: 'Enter custom ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        _generateRandomId();
                      },
                      tooltip: 'Generate random ID',
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Using auto-generated ID: ${_reminderIdController.text}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            // Reminder settings widget
            SetReminderSettingsWidget(
              reminderSettings: null,
              onReminderSettingsChanged: (settings) {
                final reminderId = _reminderIdController.text;
                Providers.remindersManager.updateReminderSettings(
                  reminderId,
                  settings,
                );

                // Generate a new ID for the next reminder
                if (!_useCustomId) {
                  _generateRandomId();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

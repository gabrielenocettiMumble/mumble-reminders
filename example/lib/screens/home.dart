import 'package:example/providers/providers.dart';
import 'package:example/widgets/set_reminder_settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:va_reminders/model/reminder_settings/reminder_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final reminderId = 'example_reminder_id';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: Providers.remindersManager,
        builder: (context, widget) {
          ReminderSettings? reminderSettings =
              Providers.remindersManager.getReminderSettings(reminderId);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Example App"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (reminderSettings != null)
                      ? ReminderInfoWidget(
                          reminderSettings: reminderSettings,
                        )
                      : const Text('No reminder set'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SetReminderSettingsWidget(
                      key: ValueKey(reminderSettings),
                      onReminderSettingsChanged: (value) {
                        Providers.remindersManager.updateReminderSettings(
                          reminderId,
                          value,
                        );
                      },
                      reminderSettings: reminderSettings,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class ReminderInfoWidget extends StatelessWidget {
  const ReminderInfoWidget({super.key, required this.reminderSettings});

  final ReminderSettings reminderSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(reminderSettings.getDescription(context)),
        Text(reminderSettings.content.title),
      ],
    );
  }
}

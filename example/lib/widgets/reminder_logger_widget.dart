import 'package:flutter/material.dart';
import 'package:mumble_reminders_example/providers/providers.dart';
import 'package:mumble_reminders_example/widgets/reminder_log_item.dart';

class ReminderLoggerWidget extends StatelessWidget {
  const ReminderLoggerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Providers.remindersManager,
      builder: (context, _) {
        final reminderSettings = Providers.remindersManager.reminderSettings;
        
        if (reminderSettings.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.notifications_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No reminders configured',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'Create a reminder to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Get list of reminder IDs and reverse it so the newest are at the top
        final reminderIds = reminderSettings.keys.toList().reversed.toList();
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reminderIds.length,
          itemBuilder: (context, index) {
            final id = reminderIds[index];
            final settings = reminderSettings[id];
            
            if (settings == null) {
              return const SizedBox.shrink();
            }
            
            return ReminderLogItem(
              id: id,
              settings: settings,
              onDelete: () {
                Providers.remindersManager.removeReminderSettings(id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reminder deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}
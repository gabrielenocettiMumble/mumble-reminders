import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';

class ReminderLogItem extends StatelessWidget {
  final String id;
  final ReminderSettings settings;
  final VoidCallback onDelete;

  const ReminderLogItem({
    super.key,
    required this.id,
    required this.settings,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    settings.content.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Are you sure you want to delete this reminder?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onDelete();
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Delete reminder',
                ),
              ],
            ),
            if (settings.content.body?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(settings.content.body ?? ''),
              ),
            Text(
              settings.getDescription(context),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'ID: $id',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
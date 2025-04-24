import 'package:flutter/material.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/reminder_frequency.dart';

class ReminderTypePicker extends StatelessWidget {
  final ReminderFrequency selectedFrequency;
  final Function(ReminderFrequency) onFrequencyChanged;

  const ReminderTypePicker({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final reminderTypes = [
      {
        'frequency': const ReminderFrequencyDaily(),
        'label': 'Daily',
        'icon': Icons.calendar_today,
        'description': 'Repeats every day at the set time'
      },
      {
        'frequency': const ReminderFrequencyWeekly(),
        'label': 'Weekly',
        'icon': Icons.view_week,
        'description': 'Repeats on the same day every week'
      },
      {
        'frequency': const ReminderFrequencyMonthly(),
        'label': 'Monthly',
        'icon': Icons.calendar_month,
        'description': 'Repeats on the same day every month'
      },
      {
        'frequency': const ReminderFrequencyEveryThreeMonths(),
        'label': 'Quarterly',
        'icon': Icons.calendar_view_month,
        'description': 'Repeats every three months'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Type',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: reminderTypes.length,
          itemBuilder: (context, index) {
            final type = reminderTypes[index];
            final isSelected = type['frequency'] == selectedFrequency;
            
            return Card(
              elevation: isSelected ? 2 : 0,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : Theme.of(context).colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onFrequencyChanged(type['frequency'] as ReminderFrequency),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['label'] as String,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : null,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                            Text(
                              type['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected) 
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
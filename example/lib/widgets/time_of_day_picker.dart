import 'package:flutter/material.dart';

class TimeOfDayPicker extends StatelessWidget {
  final ValueNotifier<TimeOfDay?> timeOfDayNotifier;
  final VoidCallback? onChanged;

  const TimeOfDayPicker({
    super.key,
    required this.timeOfDayNotifier,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time of Day',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: timeOfDayNotifier,
          builder: (context, _) {
            return InkWell(
              onTap: () => _showTimePicker(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 16),
                    Text(
                      timeOfDayNotifier.value?.format(context) ?? 'Set time',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    if (timeOfDayNotifier.value != null)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showTimePicker(context),
                        tooltip: 'Change time',
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: timeOfDayNotifier.value ?? TimeOfDay.now(),
    ).then((timeOfDay) {
      if (timeOfDay != null) {
        timeOfDayNotifier.value = timeOfDay;
        if (onChanged != null) onChanged!();
      }
    });
  }
}
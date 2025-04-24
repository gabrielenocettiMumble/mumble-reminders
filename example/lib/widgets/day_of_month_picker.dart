import 'package:flutter/material.dart';

class DayOfMonthPicker extends StatelessWidget {
  final int selectedDay;
  final bool useLastDay;
  final Function(int) onDaySelected;
  final Function(bool) onUseLastDayChanged;

  const DayOfMonthPicker({
    super.key,
    required this.selectedDay,
    required this.useLastDay,
    required this.onDaySelected,
    required this.onUseLastDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day of Month',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        
        // Option to use last day of month
        SwitchListTile(
          title: const Text('Use last day of month'),
          value: useLastDay,
          onChanged: onUseLastDayChanged,
        ),
        
        // Day number picker (if not using last day)
        if (!useLastDay)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Select day',
                border: OutlineInputBorder(),
              ),
              value: selectedDay,
              items: List.generate(
                31,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}'),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  onDaySelected(value);
                }
              },
            ),
          ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class DayOfWeekPicker extends StatelessWidget {
  final int selectedDay;
  final Function(int) onDaySelected;

  const DayOfWeekPicker({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = [
      {'value': 1, 'label': 'Monday', 'short': 'Mon'},
      {'value': 2, 'label': 'Tuesday', 'short': 'Tue'},
      {'value': 3, 'label': 'Wednesday', 'short': 'Wed'},
      {'value': 4, 'label': 'Thursday', 'short': 'Thu'},
      {'value': 5, 'label': 'Friday', 'short': 'Fri'},
      {'value': 6, 'label': 'Saturday', 'short': 'Sat'},
      {'value': 0, 'label': 'Sunday', 'short': 'Sun'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day of Week',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Select day of the week',
            border: OutlineInputBorder(),
          ),
          value: selectedDay,
          items: daysOfWeek.map((day) {
            return DropdownMenuItem<int>(
              value: day['value'] as int,
              child: Text(day['label'] as String),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onDaySelected(value);
            }
          },
        ),
      ],
    );
  }
}
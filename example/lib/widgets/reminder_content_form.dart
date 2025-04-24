import 'package:flutter/material.dart';

class ReminderContentForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final VoidCallback? onChanged;

  const ReminderContentForm({
    super.key,
    required this.titleController,
    required this.bodyController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder Content',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
            hintText: 'Enter reminder title',
          ),
          controller: titleController,
          onChanged: (_) {
            if (onChanged != null) onChanged!();
          },
        ),
        const SizedBox(height: 12),
        
        TextField(
          decoration: const InputDecoration(
            labelText: 'Body',
            border: OutlineInputBorder(),
            hintText: 'Enter reminder body (optional)',
          ),
          controller: bodyController,
          maxLines: 2,
          onChanged: (_) {
            if (onChanged != null) onChanged!();
          },
        ),
      ],
    );
  }
}
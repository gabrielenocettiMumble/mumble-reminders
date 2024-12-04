class ReminderToSchedule {
  final String reminderId;
  final DateTime date;
  final String? title;
  final String? body;

  const ReminderToSchedule({
    required this.reminderId,
    required this.date,
    required this.title,
    required this.body,
  });
}

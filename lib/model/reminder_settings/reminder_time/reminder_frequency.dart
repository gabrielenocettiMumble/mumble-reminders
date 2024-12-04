sealed class ReminderFrequency {
  const ReminderFrequency(this.label, this.dbString);

  final String label;
  final String dbString;

  factory ReminderFrequency.fromDbString(String dbString) {
    switch (dbString) {
      case 'daily':
        return const ReminderFrequencyDaily();
      case 'weekly':
        return const ReminderFrequencyWeekly();
      case 'monthly':
        return const ReminderFrequencyMonthly();
      case 'every_three_months':
        return const ReminderFrequencyEveryThreeMonths();
      default:
        return const ReminderFrequencyDaily();
    }
  }
}

class ReminderFrequencyDaily extends ReminderFrequency {
  const ReminderFrequencyDaily() : super('Daily', 'daily');
}

class ReminderFrequencyWeekly extends ReminderFrequency {
  const ReminderFrequencyWeekly() : super('Weekly', 'weekly');
}

class ReminderFrequencyMonthly extends ReminderFrequency {
  final bool lastDayOfTheMonthEnabled;

  const ReminderFrequencyMonthly({this.lastDayOfTheMonthEnabled = false})
      : super('Monthly', 'monthly');
}

class ReminderFrequencyEveryThreeMonths extends ReminderFrequency {
  final bool lastDayOfTheMonthEnabled;

  const ReminderFrequencyEveryThreeMonths(
      {this.lastDayOfTheMonthEnabled = false})
      : super('Every three months', 'every_three_months');
}

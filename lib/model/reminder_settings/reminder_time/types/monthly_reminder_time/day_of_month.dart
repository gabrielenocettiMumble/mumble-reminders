sealed class DayOfMonth {}

class LastDayOfMonth extends DayOfMonth {
  LastDayOfMonth();

  DateTime lastDayOfTheMonth(int year, int month) =>
      DateTime(year, month + 1, 0);
}

class DayOfMonthNumber extends DayOfMonth {
  final int day;

  DayOfMonthNumber(this.day);
}

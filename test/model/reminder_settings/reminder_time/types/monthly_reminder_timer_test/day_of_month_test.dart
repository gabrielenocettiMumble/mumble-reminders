import 'package:flutter_test/flutter_test.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_time/types/monthly_reminder_time/day_of_month.dart';

void main() {
  group('LastDayOfMonth', () {
    test('lastDayOfTheMonth should return the last day of the given month', () {
      final lastDayOfMonth = LastDayOfMonth();

      final date = lastDayOfMonth.lastDayOfTheMonth(2023, 1);
      expect(date, DateTime(2023, 1, 31));

      final leapYearDate = lastDayOfMonth.lastDayOfTheMonth(2024, 2);
      expect(leapYearDate, DateTime(2024, 2, 29));

      final nonLeapYearDate = lastDayOfMonth.lastDayOfTheMonth(2023, 2);
      expect(nonLeapYearDate, DateTime(2023, 2, 28));
    });
  });

  group('DayOfMonthNumber', () {
    test('should store the correct day', () {
      final dayOfMonthNumber = DayOfMonthNumber(15);
      expect(dayOfMonthNumber.day, 15);
    });
  });
}

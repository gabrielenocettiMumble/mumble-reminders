import 'package:flutter_test/flutter_test.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_content.dart';

void main() {
  group('ReminderContent', () {
    test('fromDbMap should create an instance from a database map', () {
      final map = {
        'title': 'Test Title',
        'body': 'Test Body',
      };

      final reminderContent = ReminderContent.fromDbMap(map);

      expect(reminderContent.title, 'Test Title');
      expect(reminderContent.body, 'Test Body');
    });

    test('fromDbMap should handle null body', () {
      final map = {
        'title': 'Test Title',
        'body': null,
      };

      final reminderContent = ReminderContent.fromDbMap(map);

      expect(reminderContent.title, 'Test Title');
      expect(reminderContent.body, null);
    });

    test('copyWith should return a new instance with only title updated', () {
      const reminderContent = ReminderContent(
        title: 'Original Title',
        body: 'Original Body',
      );

      final updatedReminderContent = reminderContent.copyWith(
        title: 'Updated Title',
      );

      expect(updatedReminderContent.title, 'Updated Title');
      expect(updatedReminderContent.body, 'Original Body');
    });

    test('copyWith should return a new instance with only body updated', () {
      const reminderContent = ReminderContent(
        title: 'Original Title',
        body: 'Original Body',
      );

      final updatedReminderContent = reminderContent.copyWith(
        body: 'Updated Body',
      );

      expect(updatedReminderContent.title, 'Original Title');
      expect(updatedReminderContent.body, 'Updated Body');
    });

    test(
        'copyWith should return a new instance with both title and body updated',
        () {
      const reminderContent = ReminderContent(
        title: 'Original Title',
        body: 'Original Body',
      );

      final updatedReminderContent = reminderContent.copyWith(
        title: 'Updated Title',
        body: 'Updated Body',
      );

      expect(updatedReminderContent.title, 'Updated Title');
      expect(updatedReminderContent.body, 'Updated Body');
    });

    test('toDbMap should return a map with correct values', () {
      const reminderContent = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      final map = reminderContent.toDbMap();

      expect(map['title'], 'Test Title');
      expect(map['body'], 'Test Body');
    });

    test('toDbMap should handle null body', () {
      const reminderContent = ReminderContent(
        title: 'Test Title',
        body: null,
      );

      final map = reminderContent.toDbMap();

      expect(map['title'], 'Test Title');
      expect(map['body'], null);
    });

    test('toString should return a string representation of the instance', () {
      const reminderContent = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      expect(reminderContent.toString(),
          'ReminderContent{title: Test Title, body: Test Body}');
    });

    test('== operator should return true for identical instances', () {
      const reminderContent1 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      const reminderContent2 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      expect(reminderContent1 == reminderContent2, true);
    });

    test('== operator should return false for different instances', () {
      const reminderContent1 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      const reminderContent2 = ReminderContent(
        title: 'Different Title',
        body: 'Different Body',
      );

      expect(reminderContent1 == reminderContent2, false);

      const reminderContent3 = ReminderContent(
        title: 'Test Title',
        body: 'Different Body',
      );

      expect(reminderContent1 == reminderContent3, false);
    });

    test('hashCode should return the same value for identical instances', () {
      const reminderContent1 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      const reminderContent2 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      expect(reminderContent1.hashCode, reminderContent2.hashCode);
    });

    test('hashCode should return different values for different instances', () {
      const reminderContent1 = ReminderContent(
        title: 'Test Title',
        body: 'Test Body',
      );

      const reminderContent2 = ReminderContent(
        title: 'Different Title',
        body: 'Different Body',
      );

      expect(reminderContent1.hashCode, isNot(reminderContent2.hashCode));
    });
  });
}

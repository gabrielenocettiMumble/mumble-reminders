import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mumble_reminders/database/reminders_db.dart';
import 'package:mumble_reminders/model/reminder_settings/reminder_settings.dart';

class RemindersDbManager {
  static String get _tableName => 'reminders';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        frequency TEXT NOT NULL,
        time INTEGER NOT NULL,
        day_of_week INTEGER,
        day_of_month_number INTEGER,
        last_day_of_the_month INTEGER,
        title TEXT,
        body TEXT
      )
      ''');
  }

  static Future<List<String>> getIds() async {
    Database db = await RemindersDB.instance.database;

    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((e) => e['id'] as String).toList();
  }

  static Future<ReminderSettings?> settingsForReminderID(
    String reminderId,
  ) async {
    Database db = await RemindersDB.instance.database;

    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [reminderId],
    );

    try {
      if (results.isNotEmpty) {
        return ReminderSettings.fromDbMap(results.first);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> setSettingsForReminderID(
    String reminderId,
    ReminderSettings settings,
  ) async {
    Database db = await RemindersDB.instance.database;

    try {
      List<Map<String, dynamic>> results = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [reminderId],
      );

      if (results.isEmpty) {
        Map<String, dynamic> values = settings.toDbMap();
        values['id'] = reminderId;
        await db.insert(_tableName, values);
      } else {
        await db.update(
          _tableName,
          settings.toDbMap(),
          where: 'id = ?',
          whereArgs: [reminderId],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> removeSettingsForReminderID(
    String reminderId,
  ) async {
    Database db = await RemindersDB.instance.database;

    try {
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [reminderId],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> toEmptyTable() async {
    try {
      Database db = await RemindersDB.instance.database;
      await db.delete(_tableName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

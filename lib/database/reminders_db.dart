import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:va_reminders/database/reminders_db_manager.dart';
import 'package:path/path.dart';

class RemindersDB {
  RemindersDB._privateConstructor();
  static final RemindersDB instance = RemindersDB._privateConstructor();

  static const _dbName = 'va_reminders.db';
  static const _dbVersion = 1;

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, _dbName);
    Database database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await RemindersDbManager.createTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}
}

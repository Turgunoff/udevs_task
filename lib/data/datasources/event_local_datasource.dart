import 'dart:async'; // Future uchun

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:udevs_task/domain/entities/event.dart';

class EventLocalDatasource {
  Database? _database; // Ma'lumotlar bazasi obyekti

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase(); // Ma'lumotlar bazasini ilk marta ochish
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final pathToDatabase = path.join(databasesPath, 'events.db');

    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            location TEXT,
            color INTEGER,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  // Tadbir qo'shish
  Future<void> addEvent(Event event) async {
    final db = await database;
    await db.insert('events', event.toJson());
  }

  // Tadbirlarni olish
  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  // Tadbirni yangilash
  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // Tadbirni o'chirish
  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

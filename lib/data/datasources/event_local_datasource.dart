import 'dart:async'; // Future uchun

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:udevs_task/domain/entities/event.dart';

class EventLocalDatasource {
  Database? _database; // Database object

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database =
        await _initDatabase(); // Opening the database for the first time
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
            type TEXT,
            startTime DATETIME,
            endTime DATETIME
          )
        ''');
      },
    );
  }

  // Add event
  Future<void> addEvent(Event event) async {
    final db = await database;
    await db.insert('events', event.toJson());
  }

  // Get event
  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) => Event.fromJson(maps[i]));
  }

  // Update event
  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // Delete event
  Future<void> deleteEvent(int id) async {
    final db = await database;
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

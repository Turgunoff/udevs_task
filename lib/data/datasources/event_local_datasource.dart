import 'dart:ui';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:udevs_task/domain/entities/event.dart';

class EventLocalDatasource {
  Future<Database> get database async {
    final databasePath = await getDatabasesPath();
    final pathToDatabase = path.join(databasePath, 'events.db');

    return await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            location TEXT,
            color TEXT,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<void> addEvent(Event event) async {
    final db = await database; // Ma'lumotlar bazasini olish
    await db.insert('events', {
      'name': event.name,
      'description': event.description,
      'location': event.location,
      'color': event.color.value.toString(),
      'dateTime': event.dateTime.toIso8601String(),
    });
  }

  Future<List<Event>> getEvents() async {
    final db = await database; // Ma'lumotlar bazasini olish
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        location: maps[i]['location'],
        color: Color(int.parse(maps[i]['color'])), // Rangni qayta tiklash
        dateTime: DateTime.parse(maps[i]['dateTime']), // Vaqtni qayta tiklash
      );
    });
  }
  // Tadbir qo'shish, o'qish, yangilash va o'chirish funksiyalari
  // ...
}

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
    final db = await database;
    await db.insert('events', event.toJson());
  }
}

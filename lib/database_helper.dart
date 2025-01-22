import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'activity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'detox_diary.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE activities(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            isGood INTEGER,
            isCompleted INTEGER
          )
          ''',
        );
      },
    );
  }

  Future<void> insertActivity(String name, bool isGood, bool isCompleted) async {
    final db = await _getDatabase();
    await db.insert(
      'activities',
      {
        'name': name,
        'isGood': isGood ? 1 : 0,
        'isCompleted': isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteActivity(String name) async {
    final db = await _getDatabase();
    await db.delete(
      'activities',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Activity>> getActivities(bool isGood) async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'activities',
      where: 'isGood = ?',
      whereArgs: [isGood ? 1 : 0],
    );

    return List.generate(maps.length, (i) {
      return Activity(
        maps[i]['name'],
        maps[i]['isCompleted'] == 1,
      );
    });
  }

  Future<void> updateActivityStatus(Activity activity, bool isCompleted) async {
    final db = await _getDatabase();
    await db.update(
      'activities',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'name = ?',
      whereArgs: [activity.name],
    );
  }
}

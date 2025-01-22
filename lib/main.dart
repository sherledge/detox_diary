import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'home_screen.dart';
import 'introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDatabaseEmpty = await initializeDatabase(); // check database emoty or not
  runApp(MyApp(isDatabaseEmpty: isDatabaseEmpty));
}

Future<bool> initializeDatabase() async {
 final database = await openDatabase(
    join(await getDatabasesPath(), 'detox_diary.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(''' 
        CREATE TABLE activities(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          isGood INTEGER,
          isCompleted INTEGER
        )
      ''');
    },
  );

  // check tables are emptyy
  final List<Map<String, dynamic>> maps = await database.query('activities');
  if (maps.isEmpty) {
    await _initializeDefaultActivities(database); // insert prevalues
    return true;
  }
  return false;
}

// insert prevalues
Future<void> _initializeDefaultActivities(Database db) async {
  final defaultActivities = [
    {'name': 'Exercise', 'isGood': 1, 'isCompleted': 0},
    {'name': 'Meditation', 'isGood': 1, 'isCompleted': 0},
    {'name': 'Social Media', 'isGood': 0, 'isCompleted': 0},
    {'name': 'Junk Food', 'isGood': 0, 'isCompleted': 0},
  ];

  for (var activity in defaultActivities) {
    await db.insert(
      'activities',
      {
        'name': activity['name'],
        'isGood': activity['isGood'],
        'isCompleted': activity['isCompleted'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class MyApp extends StatelessWidget {
  final bool isDatabaseEmpty;

 const MyApp({super.key, required this.isDatabaseEmpty,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dopamine Tracker',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(), 
      ),
      home: isDatabaseEmpty ? const IntroductionScreen() : const HomeScreen(),
    );
  }
}

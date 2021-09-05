import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

const String _DATABASE_NAME = 'puzzlemath_database.db';

const String _CHALLENGES_TABLE = '''
  CREATE TABLE challenges(
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    solution INTEGER,
    markers TEXT,
    state INTEGER);
''';

Future<Database> connectToDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final String databasePath = await getDatabasesPath();
  return openDatabase(
    join(databasePath, _DATABASE_NAME),
    onCreate: _onCreateDatabase,
    version: 1,
  );
}

void _onCreateDatabase(db, version) async {
  await db.execute(_CHALLENGES_TABLE);
}

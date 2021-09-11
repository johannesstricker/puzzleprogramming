import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:async/async.dart';

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

void _onCreateDatabase(db, version) async {
  await db.execute(_CHALLENGES_TABLE);
}

class Database {
  Database._internal();

  static final Database _instance = new Database._internal();

  static Database get instance => _instance;

  static sqflite.Database? _connection;

  final _connectionMemoizer = AsyncMemoizer<sqflite.Database>();

  Future<sqflite.Database> get connection async {
    if (_connection == null) {
      _connection = await _connectionMemoizer.runOnce(() async {
        return await _connect();
      });
    }
    return _connection!;
  }

  Future<sqflite.Database> _connect() async {
    // .. Copy initial database (data.db) from assets file to database path
    String databasePath = await sqflite.getDatabasesPath();
    String databaseFilePath = join(databasePath, _DATABASE_NAME);
    return await sqflite.openDatabase(databaseFilePath,
        onCreate: _onCreateDatabase, version: 1);
  }
}

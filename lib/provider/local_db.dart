import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist_basic/main.dart';
import 'package:todolist_basic/model/task_model.dart';

/// initialize db while LocalDb instance is created
///
/// make sure to call from [main]

const String kDbName = 'todo.db';
const String kTodoTableName = 'todo_table';
const int kDbVersion = 1;

class LocalDb {
  static Database? _db;

  Database? get database => _db;

  void toggle(String table, TodoModel todo) async {
    await _db?.update(
      table,
      {
        'isDone': todo.isDone ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [
        todo.id,
      ],
    );
  }

  void delete(String table, TodoModel todo) async {
    await _db?.delete(
      table,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  /// writes into [db] table
  //! TODO: fire a widget-message upon successful save
  Future<String>? insert(String table, TodoModel todo) async {
    final result = await _db?.insert(
      table,
      todo.toMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return result.toString();
  }

  Future<List<TodoModel>?> readAllSavedTodo() async {
    // prepare
    if (_db == null) return null;

    // read
    final List<Map<String, dynamic>> rows = await _db!.query(
      kTodoTableName,
    );

    // convert
    final todos = rows.map((map) => TodoModel.fromMap(map)).toList();

    return todos;
  }

  LocalDb() {
    _db ?? _initializeDatabase().then((db) => _db = db);
  }

  Future<void> ensureInitialized() async {
    await LocalDb()._initializeDatabase();
  }

  Future<Database?> _initializeDatabase() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), kDbName),
      onCreate: _onCreate,
      version: kDbVersion,
    );
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $kTodoTableName (
        id TEXT PRIMARY KEY,
        title TEXT,
        isDone INTEGER,
        creationTime INTEGER
      )
    ''');
  }
}

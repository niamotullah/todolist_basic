import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqffi;
import 'package:todolist_basic/model/task_model.dart';

const String kDbName = 'todo.db';
const String kTodoTableName = 'todo_table';
const int kDbVersion = 2;

class LocalDb {
  static Database? _db;

  Database? get database => _db;

  void toggle(String table, TodoModel todo) async {
    await _db?.update(
      table,
      {
        'isDone': todo.isDone ? 1 : 0,
        'lastModified': todo.lastModified,
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

  static Future<void> ensureInitialized() async {
    await LocalDb()._initializeDatabase();
  }

  FutureOr<void> _onDbUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion == 1 && newVersion == 2) {
      await db.transaction(
        (txn) async {
          // rename old table
          await txn.execute(
            'ALTER TABLE $kTodoTableName RENAME TO ${kTodoTableName}_old;',
          );

          // create new table
          await txn.execute('''
                          CREATE TABLE $kTodoTableName (
                            id TEXT PRIMARY KEY,
                            title TEXT,
                            isDone INTEGER,
                            lastModified INTEGER
                          )
                      ''');

          // copy old to new table
          await txn.execute('''
                INSERT INTO $kTodoTableName (id, title, isDone, lastModified)
                SELECT id, title, isDone, creationTime
                FROM ${kTodoTableName}_old;
              ''');

          // delete old table
          await txn.execute('DROP TABLE ${kTodoTableName}_old');
        },
      );
    }
  }

  Future<Database?> _initializeDatabase() async {
    if (_db != null) return _db;

    getDbFullPath() async => join(await getDatabasesPath(), kDbName);

    if (!Platform.isAndroid && !Platform.isIOS) {
      // Initialize FFI for desktop platforms
      sqffi.sqfliteFfiInit();
      sqffi.databaseFactory = sqffi.databaseFactoryFfi;
      _db = await sqffi.databaseFactory.openDatabase(
        await getDbFullPath(),
        options: sqffi.OpenDatabaseOptions(
          version: kDbVersion,
          onCreate: _onCreate,
          onUpgrade: _onDbUpgrade,
        ),
      );
    } else {
      _db = await openDatabase(
        await getDbFullPath(),
        version: kDbVersion,
        onCreate: _onCreate,
        onUpgrade: _onDbUpgrade,
      );
    }
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $kTodoTableName (
        id TEXT PRIMARY KEY,
        title TEXT,
        isDone INTEGER,
        lastModified INTEGER
      )
    ''');
  }
}

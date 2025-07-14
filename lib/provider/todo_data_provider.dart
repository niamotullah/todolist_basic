import 'package:flutter/foundation.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/provider/local_db.dart';

class TodoDataProvider extends ChangeNotifier {
  List<TodoModel> _tasks = [];
  final _db = LocalDb();

  Future<void> ensureInitialized() async {
    // prepare
    await _db.ensureInitialized();

    // read
    final result = await _db.readAllSavedTodo();

    // populate
    _tasks = result ?? [];
  }

  /// list of tasks that has not completed yet
  ///
  /// where [task.isDone = false]
  List<TodoModel> get tasks {
    return _tasks;
    // return _tasks.where((element) => !element.isDone).toList();
  }

  /// list of tasks that has marked as Done
  ///
  /// where [task.isDone = true]
  List<TodoModel> get completedTasks =>
      _tasks.where((element) => element.isDone).toList();

  void addTask(TodoModel todo) {
    // write into this obj
    _tasks.insert(0, todo);

    // into db
    _db.insert(kTodoTableName, todo);

    // update UI
    notifyListeners();
  }

  void removeTask(TodoModel task) {
    // from this obj
    _tasks.remove(task); // pass : 1

    // from db
    _db.delete(kTodoTableName, task); // pass : 1

    // update UI
    notifyListeners();
  }

  void _toggleTodo(TodoModel todo) {
    final indexOf = _tasks.indexWhere((t) => todo.id == t.id);
    _tasks[indexOf].toggle();
  }

  void toggle(TodoModel task) {
    // toggle on this obj
    _toggleTodo(task); // pass : 1

    // toggle on db
    _db.toggle(kTodoTableName, task); // pass : 1

    notifyListeners();
  }
}

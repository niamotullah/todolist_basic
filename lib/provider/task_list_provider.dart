import 'package:flutter/foundation.dart';
import 'package:todolist_basic/model/task_model.dart';

// todo: refactor based on this provider
class TaskListProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  /// list of tasks that has not completed yet
  ///
  /// where [task.isDone = false]
  List<TaskModel> get tasks =>
      _tasks.where((element) => !element.isDone).toList();

  /// list of tasks that has marked as Done
  ///
  /// where [task.isDone = true]
  List<TaskModel> get completedTasks =>
      _tasks.where((element) => element.isDone).toList();

  // !debug: remove
  TaskListProvider() {
    if (kDebugMode) {
      List<TaskModel> tmpList = [
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'bbbbbbbbbb', isCompleted: true),
        TaskModel(title: 'cccccccccccc'),
        TaskModel(title: 'ialfj'),
        TaskModel(title: 'afi;o1p'),
        TaskModel(title: 'a;lsjfl', isCompleted: true),
        TaskModel(title: 'als;fk'),
      ];
      _tasks.addAll(tmpList);
    }
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  //todo: remove from both list
  void removeTask(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggle(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

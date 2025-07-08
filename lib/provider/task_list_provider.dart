import 'package:flutter/foundation.dart';
import 'package:todolist_basic/model/task_model.dart';

// todo: refactor based on this provider
class TaskListProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  // !debug: remove
  TaskListProvider() {
    if (kDebugMode) {
      List<TaskModel> tmpList = [
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
        TaskModel(title: 'aaaaaa'),
      ];
      _tasks.addAll(tmpList);
    }
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void toggle(int index) {
    _tasks[index].toggle();
    notifyListeners();
  }
}

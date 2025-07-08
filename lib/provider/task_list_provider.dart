import 'package:flutter/material.dart';
import 'package:todolist_basic/model/task_model.dart';

// todo: refactor based on this provider
class TaskListProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  int get tasksCount => _tasks.length;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(TaskModel task) {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  //todo
  void toggle(TaskModel task) {}
}

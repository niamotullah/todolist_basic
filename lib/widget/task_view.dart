import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/provider/todo_data_provider.dart';

class TaskView extends StatelessWidget {
  const TaskView({required this.task, super.key});
  final TodoModel task;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoDataProvider>(
      builder: (context, taskListProvider, child) {
        return Card(
          child: ListTile(
            leading: Checkbox.adaptive(
              value: task.isDone,
              onChanged: (value) {
                if (value != null) taskListProvider.toggle(task);
              },
            ),
            title: Text(task.title),
          ),
        );
      },
    );
  }
}

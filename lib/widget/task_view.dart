import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/provider/task_list_provider.dart';

class TaskView extends StatelessWidget {
  const TaskView({required this.task, super.key});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
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

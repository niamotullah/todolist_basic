import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/provider/task_list_provider.dart';

class TaskView extends StatelessWidget {
  const TaskView({required taskIndex, super.key}) : index = taskIndex;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
      builder: (context, taskListProvider, child) {
        final task = taskListProvider.tasks[index];
        return Card(
          child: ListTile(
            leading: Checkbox.adaptive(
              // todo make it work
              value: task.isDone,
              onChanged: (value) {
                if (value != null) taskListProvider.toggle(index);
              },
            ),
            title: Text(task.title),
          ),
        );
      },
    );
  }
}

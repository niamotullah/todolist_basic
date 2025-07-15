import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/provider/todo_data_provider.dart';

class TaskView extends StatefulWidget {
  const TaskView({required this.task, super.key});
  final TodoModel task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoDataProvider>(
      builder: (context, taskListProvider, child) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Checkbox.adaptive(
              value: widget.task.isDone,
              onChanged: (value) {
                if (value != null) taskListProvider.toggle(widget.task);
              },
            ),
            title: Text(
              widget.task.title,
              style:
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    decoration: widget.task.isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
            ),
          ),
        );
      },
    );
  }
}

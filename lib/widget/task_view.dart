import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/provider/todo_data_provider.dart';

class TaskView extends StatefulWidget {
  final TodoModel task;
  const TaskView({required this.task, super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoDataProvider>(
      builder: (context, taskListProvider, child) {
        return Card(
          surfaceTintColor: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.all(0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            enableFeedback: true,
            leading: Checkbox.adaptive(
              value: widget.task.isDone,
              onChanged: (value) {
                if (value != null) taskListProvider.toggle(widget.task);
              },
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.drag_handle),
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

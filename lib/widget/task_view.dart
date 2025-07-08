import 'package:flutter/material.dart';
import '../model/task_model.dart';

class TaskView extends StatelessWidget {
  const TaskView({required this.task, super.key});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox.adaptive(
          // todo make it work
          value: false,
          onChanged: (value) => false,
        ),

        title: Text(task.title),
      ),
    );
  }
}

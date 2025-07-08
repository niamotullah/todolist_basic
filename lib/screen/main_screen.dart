import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:todolist_basic/widget/add_new_task.dart';
import 'package:todolist_basic/provider/task_list_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
      builder: (context, value, child) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Tasks'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Task',
          onPressed: () async {
            final newItem = await showModalBottomSheet<TaskModel>(
              showDragHandle: true,
              context: context,
              builder: (context) => AddNewTask(),
            );

            if (newItem == null) return;
            if (context.mounted) {
              context.read<TaskListProvider>().addTask(newItem);
            }
          },
          enableFeedback: true,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.tasksCount,
          itemBuilder: (context, index) {
            final task = value.tasks[index];

            return ListTile(
              leading: Checkbox.adaptive(
                //todo make it work
                value: false,
                onChanged: (value) => false,
              ),

              title: Text(task.title),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

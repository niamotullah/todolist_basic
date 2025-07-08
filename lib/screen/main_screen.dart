import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_model.dart';
import '../provider/task_list_provider.dart';
import '../widget/add_new_task.dart';
import '../widget/task_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListProvider>(
      builder: (context, value, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Tasks'),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add Task',
            onPressed: () async {
              final newItem = await showModalBottomSheet<TaskModel>(
                isDismissible: false,
                enableDrag: false,
                showDragHandle: true,

                useSafeArea: true,
                isScrollControlled: true,
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
          body: value.tasks.isEmpty
              ? Center(
                  child: Text(
                    '''No tasks! \nAdd by tapping into '+' button''',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: value.tasks.length,
                  itemBuilder: (context, index) {
                    final task = value.tasks[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      // confirmDismiss: (direction) async {
                      //   final isConfirm = await showDialog<bool>(
                      //     context: context,
                      //     builder: (ctx) => Center(
                      //       child: AlertDialog(
                      //         content: Text(
                      //           'Are sure you want to delete this Task?',
                      //         ),
                      //         alignment: Alignment.center,
                      //         title: Text('Delete this Task?'),
                      //         actions: [
                      //           TextButton(
                      //             onPressed: () => Navigator.of(ctx).pop(),
                      //             child: Text('Cancel'),
                      //           ),
                      //           ElevatedButton(
                      //             onPressed: () {
                      //               value.removeTask(task);
                      //               Navigator.of(ctx).pop();
                      //             },
                      //             child: Text('Yes'),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      //   if (isConfirm == null || !isConfirm) return;
                      //   return null;
                      // },
                      key: Key(task.id),
                      onDismissed: (direction) => value.removeTask(task),
                      child: TaskView(taskIndex: index),
                    );
                  },
                ),
        );
      },
    );
  }
}

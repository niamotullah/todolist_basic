import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_model.dart';
import '../provider/todo_data_provider.dart';
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
    const noTodoItems = Center(
      child: Text(
        '''No tasks! \nAdd by tapping into '+' button''',
        textAlign: TextAlign.center,
      ),
    );

    myTodoItems(context, TodoDataProvider taskListProvider) {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: taskListProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskListProvider.tasks[index];
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
            onDismissed: (direction) => taskListProvider.removeTask(task),
            child: TaskView(task: task),
          );
        },
      );
    }

    final myAppBar = AppBar(
      centerTitle: true,
      title: const Text('Tasks'),
    );

    final addNewTaskButton = FloatingActionButton(
      tooltip: 'Add Task',
      onPressed: () async {
        final newItem = await showModalBottomSheet<TodoModel>(
          isDismissible: false,
          enableDrag: false,
          showDragHandle: true,

          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => const AddNewTask(),
        );

        if (newItem == null) return;
        if (context.mounted) {
          context.read<TodoDataProvider>().addTask(newItem);
        }
      },
      enableFeedback: true,
      child: const Icon(Icons.add),
    );

    const dbLoading = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading Tasks...'),
        ],
      ),
    );
    return Consumer<TodoDataProvider>(
      builder: (context, todoDataProvider, child) => Scaffold(
        appBar: myAppBar,
        floatingActionButton: addNewTaskButton,
        body: FutureBuilder(
          future: todoDataProvider.ensureInitialized(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return dbLoading;
            }

            return todoDataProvider.tasks.isEmpty
                ? noTodoItems
                : myTodoItems(context, todoDataProvider);
          },
        ),
      ),
    );
  }
}

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist_basic/model/task_model.dart';
import 'package:provider/provider.dart';
import 'package:todolist_basic/provider/task_list_provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (BuildContext context) => TaskListProvider(),
        child: MainScreen(),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}

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

// todo: refactor, move, screen
class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _formController = GlobalKey<FormState>();

  final _titleEditingController = TextEditingController();

  String? _title = '';

  @override
  void dispose() {
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formController,
      child: Container(
        padding: EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Column(
          children: [
            // task name
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'title field cannot be empty';
                }

                return null;
              },
              keyboardType: TextInputType.number,
              maxLength: 40,
              controller: _titleEditingController,
              onSaved: (newValue) => _title = newValue,
              decoration: InputDecoration(
                hintText: 'Something',
                floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                labelText: 'Title',
                counter: ValueListenableBuilder(
                  valueListenable: _titleEditingController,
                  builder: (context, value, child) => Text(
                    '${_titleEditingController.value.text.length}/40',
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 8),
            Divider(),
            // action button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // close addNewItem
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    //validate and save
    final isValid = _formController.currentState?.validate();
    if (isValid == null || !isValid) return;
    _formController.currentState?.save();

    // return Task

    final newTask = TaskModel(title: _title!);

    Navigator.of(context).pop<TaskModel>(newTask);
  }
}

import 'dart:io';

import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:todolist_basic/model/task.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !(Platform.isAndroid || Platform.isIOS),
      builder: (context) => TodoApp(),
    ),
  );
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _tasks = [
    Task(title: 'task 1'),
    Task(title: 'task 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: _createNewTask,
        enableFeedback: true,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final title = _tasks[index].title;

          return ListTile(
            leading: Checkbox.adaptive(
              //todo make it work
              value: false,
              onChanged: (value) => false,
            ),

            title: Text(title),
          );
        },
      ),
    );
  }

  Future<void> _createNewTask() async {
    final newItem = await showModalBottomSheet<Task>(
      showDragHandle: true,
      context: context,
      builder: (context) => AddNewTask(),
    );
    if (newItem == null) return;
    setState(() => _tasks.insert(0, newItem));
  }
}

// todo: refactor, move, screen
class AddNewTask extends StatelessWidget {
  AddNewTask({super.key});

  final _formController = GlobalKey<FormState>();
  final _titleEditingController = TextEditingController();

  String? _title = '';

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
              controller: _titleEditingController,
              maxLength: 40,
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

    final newTask = Task(title: _title!);

    Navigator.of(context).pop<Task>(newTask);
  }
}

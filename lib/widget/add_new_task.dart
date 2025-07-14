import 'package:flutter/material.dart';
import 'package:todolist_basic/model/task_model.dart';

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
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formController,
        child: Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // task name
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'title field cannot be empty';
                  }

                  return null;
                },
                keyboardType: TextInputType.text,
                maxLength: 40,
                controller: _titleEditingController,
                onSaved: (newValue) => _title = newValue,
                decoration: InputDecoration(
                  hintText: 'Something',
                  floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelText: 'Title',
                  counter: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _titleEditingController,
                    builder: (context, value, child) => Text(
                      '${_titleEditingController.value.text.length}/40',
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 8), Divider(), // action button
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
                    onPressed: _submitForm,
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    //validate and save
    final isValid = _formController.currentState?.validate();
    if (isValid == null || !isValid) return;
    _formController.currentState?.save();

    // return Task

    final newTask = TodoModel(title: _title!);

    Navigator.of(context).pop<TodoModel>(newTask);
  }
}

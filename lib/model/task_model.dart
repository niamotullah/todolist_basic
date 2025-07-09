import 'package:uuid/uuid.dart';

Uuid uuid = Uuid()..v4();

class TaskModel {
  String title;
  final String id;
  bool isDone;

  TaskModel({required this.title, bool? isCompleted})
    : id = uuid.v4(),
      isDone = isCompleted ?? false;

  void toggle({bool? value}) => isDone = value ?? !isDone;
}

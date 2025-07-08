import 'package:uuid/uuid.dart';

Uuid uuid = Uuid()..v4();

class TaskModel {
  String title;
  final String id;
  bool isDone = false;
  TaskModel({required this.title}) : id = uuid.v4();
  void toggle() => isDone = !isDone;
}

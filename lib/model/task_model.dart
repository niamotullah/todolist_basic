import 'package:todolist_basic/extension/date_time.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid()..v4();

class TodoModel {
  String title;
  String id;
  bool isDone;
  int creationTime;

  TodoModel({required this.title, bool? isCompleted})
    : id = uuid.v4(),
      isDone = isCompleted ?? false,
      creationTime = DateTime.now().secondsSinceEpoch();

  void toggle({bool? value}) => isDone = value ?? !isDone;

  Map<String, Object?> get toMap => {
    'id': id,
    'title': title,
    'isDone': isDone ? 1 : 0,
    'creationTime': creationTime,
  };

  factory TodoModel.fromMap(Map<String, Object?> map) {
    // CREATE TABLE $kTodoTableName (
    //   id TEXT PRIMARY KEY,
    //   title TEXT,
    //   isDone INTEGER,
    //   creationTime INTEGER
    // )
    final taskId = map['id'] as String;
    final taskTitle = map['title'] as String;
    final taskIsDone = map['isDone'] as int == 1;
    final taskCreationTime = map['creationTime'] as int;

    return TodoModel(
        title: taskTitle,
        isCompleted: taskIsDone,
      )
      ..id = taskId
      ..creationTime = taskCreationTime;
  }
}

import 'package:todolist_basic/extension/date_time.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid()..v4();

class TodoModel {
  String _title;
  String id;
  int lastModified;

  bool _isDone;
  bool get isDone => _isDone;
  set isDone(bool value) {
    _isDone = value;
    _onChange();
  }

  String get title => _title;
  set title(String value) {
    _title = value;
    _onChange();
  }

  TodoModel({required String title, bool? isCompleted})
    : id = uuid.v4(),
      _title = title,
      _isDone = isCompleted ?? false,
      lastModified = DateTime.now().secondsSinceEpoch();

  void toggle({bool? value}) {
    isDone = value ?? !_isDone;
    _onChange();
  }

  Map<String, dynamic> get toMap {
    return {
      'id': id,
      'title': _title,
      'isDone': _isDone ? 1 : 0,
      'lastModified': lastModified,
    };
  }

  factory TodoModel.fromMap(Map<String, Object?> map) {
    final taskId = map['id'] as String;
    final taskTitle = map['title'] as String;
    final taskIsDone = map['isDone'] as int == 1;
    final lastModified = map['lastModified'] as int;

    return TodoModel(
        title: taskTitle,
        isCompleted: taskIsDone,
      )
      ..id = taskId
      ..lastModified = lastModified;
  }

  void _onChange() => lastModified = DateTime.now().secondsSinceEpoch();
}

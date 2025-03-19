import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  bool reminder;

  @HiveField(5)
  String category;

  @HiveField(6)
  bool isPinned;

  Todo({
    this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.reminder = false,
    this.category = 'Personal',
    this.isPinned = false,
  });
}

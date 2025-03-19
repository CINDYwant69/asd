import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/hive_service.dart';

class TodoProvider with ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Todo> get todos => _hiveService.todoBox.values.toList();

  void addTodo(Todo todo) {
    _hiveService.todoBox.add(todo);
    notifyListeners();
  }

  void updateTodo(int id, String newTitle) {
    final todo = _hiveService.todoBox.values.firstWhere(
      (todo) => todo.id == id,
    );
    todo.title = newTitle;
    todo.save();
    notifyListeners();
  }

  void deleteTodo(int id) {
    final todo = _hiveService.todoBox.values.firstWhere(
      (todo) => todo.id == id,
    );
    todo.delete();
    notifyListeners();
  }

  void toggleTodoStatus(int id) {
    final todo = _hiveService.todoBox.values.firstWhere(
      (todo) => todo.id == id,
    );
    todo.isCompleted = !todo.isCompleted;
    todo.save();
    notifyListeners();
  }
}

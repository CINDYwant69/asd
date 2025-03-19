import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../utils/animations.dart';
import '../widgets/todo_item.dart';
import '../widgets/search_bar.dart' as custom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Open filter dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Use the custom SearchBar with the prefix
          custom.SearchBar(
            onSearch: (query) {
              // Implement search functionality here
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todoProvider.todos.length,
              itemBuilder: (context, index) {
                final todo = todoProvider.todos[index];
                final animationController = AnimationController(
                  duration: const Duration(milliseconds: 300),
                  vsync: this, // Use the TickerProviderStateMixin
                );

                // Start the animation
                animationController.forward();

                return TaskAnimations.slideTransition(
                  animationController,
                  TodoItem(
                    todo: todo,
                    onToggle: () => todoProvider.toggleTodoStatus(todo.id!),
                    onEdit: () => _editTodo(context, todoProvider, todo),
                    onDelete: () => todoProvider.deleteTodo(todo.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    final textController = TextEditingController();
    DateTime? dueDate;
    bool reminder = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add To-Do',
            style: TextStyle(
              fontFamily: 'Quicksand',
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter your task',
                  hintStyle: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).hintColor,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Due Date',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dueDate = pickedDate;
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Set Reminder',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Switch(
                  value: reminder,
                  onChanged: (value) => reminder = value,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  final todo = Todo(
                    id: DateTime.now().millisecondsSinceEpoch,
                    title: textController.text,
                    dueDate: dueDate,
                    reminder: reminder,
                  );
                  Provider.of<TodoProvider>(
                    context,
                    listen: false,
                  ).addTodo(todo);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editTodo(BuildContext context, TodoProvider todoProvider, Todo todo) {
    final textController = TextEditingController(text: todo.title);
    DateTime? dueDate = todo.dueDate;
    bool reminder = todo.reminder;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit To-Do',
            style: TextStyle(
              fontFamily: 'Quicksand',
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Edit your task',
                  hintStyle: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).hintColor,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Due Date',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      dueDate = pickedDate;
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Set Reminder',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Switch(
                  value: reminder,
                  onChanged: (value) => reminder = value,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  todo.title = textController.text;
                  todo.dueDate = dueDate;
                  todo.reminder = reminder;
                  todo.save();
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

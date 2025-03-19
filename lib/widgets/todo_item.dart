import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/tts_service.dart';
import '../services/translation_service.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final TtsService _ttsService = TtsService();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => onToggle(),
          activeColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color:
                todo.isCompleted
                    ? Colors.grey
                    : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: FutureBuilder<String>(
          future: TranslationService.translateToFilipino(todo.title),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(
                snapshot.data ?? todo.title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Colors.grey[600],
                ),
              );
            }
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () => _ttsService.speak(todo.title),
            ),
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

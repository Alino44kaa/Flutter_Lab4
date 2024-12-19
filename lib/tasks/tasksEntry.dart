import 'package:flutter/material.dart';
import 'tasksModel.dart';

class TasksEntry extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();

  TasksEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  title: titleController.text,
                  isCompleted: false,
                );
                tasksModel.add(task);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}

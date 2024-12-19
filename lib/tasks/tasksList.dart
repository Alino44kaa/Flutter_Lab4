import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'tasksModel.dart';
import 'tasksEntry.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  void initState() {
    super.initState();
    // Load data from the database
    tasksModel.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tasks'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksEntry()),
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: model.tasks.length,
              itemBuilder: (context, index) {
                final task = model.tasks[index];
                return Slidable(
                  key: ValueKey(task.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _editTask(context, task);
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          model.delete(task.id!);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        model.toggleCompletion(task);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _editTask(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  tasksModel.update(
                    Task(
                      id: task.id,
                      title: titleController.text,
                      isCompleted: task.isCompleted,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'tasksDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';

class Task {
  int? id;
  String title;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.isCompleted,
  });
}

class TasksModel extends Model {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // Load data from the database
  Future<void> loadTasks() async {
    final data = await TasksDBWorker.db.getAllTasks();
    _tasks = data.map((item) {
      return Task(
        id: item['id'],
        title: item['title'],
        isCompleted: item['isCompleted'] == 1,
      );
    }).toList();
    notifyListeners();
  }

  void add(Task task) async {
    final id = await TasksDBWorker.db.insertTask({
      'title': task.title,
      'isCompleted': task.isCompleted ? 1 : 0,
    });
    task.id = id;
    _tasks.add(task);
    notifyListeners();
  }

  void delete(int id) async {
    await TasksDBWorker.db.deleteTask(id);
    _tasks.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void update(Task task) async {
    await TasksDBWorker.db.updateTask({
      'id': task.id,
      'title': task.title,
      'isCompleted': task.isCompleted ? 1 : 0,
    });
    int index = _tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void toggleCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await TasksDBWorker.db.updateTask({
      'id': task.id,
      'title': task.title,
      'isCompleted': task.isCompleted ? 1 : 0,
    });
    notifyListeners();
  }
}

final tasksModel = TasksModel();

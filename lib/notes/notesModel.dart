import 'notesDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';

class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });
}

class NotesModel extends Model {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  // Load data from the database
  Future<void> loadNotes() async {
    final data = await NotesDBWorker.db.getAllNotes();
    _notes = data.map((item) {
      return Note(
        id: item['id'],
        title: item['title'],
        content: item['content'],
      );
    }).toList();
    notifyListeners();
  }

  void add(Note note) async {
    final id = await NotesDBWorker.db.insertNote({
      'title': note.title,
      'content': note.content,
    });
    note.id = id;
    _notes.add(note);
    notifyListeners();
  }

  void delete(int id) async {
    await NotesDBWorker.db.deleteNote(id);
    _notes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void update(Note note) async {
    await NotesDBWorker.db.updateNote({
      'id': note.id,
      'title': note.title,
      'content': note.content,
    });
    int index = _notes.indexWhere((item) => item.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      notifyListeners();
    }
  }
}

final notesModel = NotesModel();

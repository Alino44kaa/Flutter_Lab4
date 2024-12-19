import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notesModel.dart';
import 'notesEntry.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  void initState() {
    super.initState();
    // Load data from the database
    notesModel.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotesEntry()),
                    );
                  },
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: model.notes.length,
              itemBuilder: (context, index) {
                final note = model.notes[index];
                return Slidable(
                  key: ValueKey(note.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _editNote(context, note);
                        },
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          model.delete(note.id!);
                        },
                        icon: Icons.delete,
                        label: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    onTap: () => _showNoteDetails(context, note),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _editNote(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

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
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  notesModel.update(
                    Note(
                      id: note.id,
                      title: titleController.text,
                      content: contentController.text,
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

  void _showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note.title),
          content: Text(note.content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';

import '../dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesListView(
      {Key? key, required this.notes, required this.onDeleteNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(12, 12, 12, 12),
            ),
            alignment: Alignment.center,
            child: ListTile(
              title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              selectedColor: Colors.amber,
              trailing: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[400],
                ),
                child: IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  color: Colors.black54,
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

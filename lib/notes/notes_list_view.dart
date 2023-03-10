import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import '../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView(
      {Key? key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
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
              onTap: () {
                onTap(note);
              },
              trailing: SizedBox(
                width: 99.0,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow[600],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.change_circle_outlined),
                          color: Colors.black54,
                          onPressed: () {
                            onTap(note);
                          },
                        ),
                      ),
                    ),
                    Container(
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
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

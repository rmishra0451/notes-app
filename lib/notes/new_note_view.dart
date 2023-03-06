import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void deleteNote() async {
    final note = _note;
    if (_textController.text.isNotEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      final newNote = await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Column(
        children: [
          const Spacer(),
          FutureBuilder(
            future: createNewNote(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _note = snapshot.data as DatabaseNote;
                  _setupTextControllerListener();
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Start tying your note here....',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          )),
                    ),
                  );
                default:
                  return const CircularProgressIndicator.adaptive();
              }
            },
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _saveNoteIfTextNotEmpty();
                    Navigator.of(context).pop();
                  },
                  label: const Text('Save'),
                  icon: const Icon(Icons.save_alt),
                  backgroundColor: Colors.greenAccent,
                  heroTag: 'btn1',
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    deleteNote();
                    Navigator.of(context).pop();
                  },
                  label: const Text('Discard'),
                  icon: const Icon(Icons.delete),
                  backgroundColor: Colors.pink,
                  heroTag: 'btn2',
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

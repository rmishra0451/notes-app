import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import '../constants/routes.dart';
import '../dialogs/logout_dialog.dart';
import '../enums/menu_actions.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    //not needed since we added ensureDbIsOpen Function
    // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Log out'))
                ];
              },
            )
          ],
        ),
        body: Center(
          child: (FutureBuilder(
              future: _notesService.getOrCreateUser(email: userEmail),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return StreamBuilder(
                        stream: _notesService.allNotes,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const CircularProgressIndicator.adaptive();
                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                final allNotes =
                                    snapshot.data as List<DatabaseNote>;
                                return ListView.builder(
                                  itemCount: allNotes.length,
                                  itemBuilder: (context, index) {
                                    final note = allNotes[index];
                                    return ListTile(
                                      title: Text(
                                        note.text,
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      selectedColor: Colors.amber,
                                    );
                                  },
                                );
                              } else {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                            default:
                              return const CircularProgressIndicator.adaptive();
                          }
                        });

                  default:
                    return const CircularProgressIndicator.adaptive();
                }
              })),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed(newNoteRoute);
          },
          label: const Text('Add Note'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }
}

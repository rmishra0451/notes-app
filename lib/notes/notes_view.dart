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
  void dispose() {
    _notesService = NotesService();
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
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
                            case ConnectionState.active:
                              return const Text('Add your first note...',
                                  // textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color: Colors.black12));
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
            Navigator.of(context).pushNamed(newNotesRoute);
          },
          label: const Text('Add Note'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:mynotes/notes/notes_list_view.dart';
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
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: PopupMenuButton<MenuAction>(
                icon: const Icon(Icons.power_settings_new),
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final navigator = Navigator.of(context);
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        await AuthService.firebase().logOut();
                        navigator.pushNamedAndRemoveUntil(
                            loginRoute, (_) => false);
                      }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text('Log out'))
                  ];
                },
              ),
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
                                return NotesListView(
                                  notes: allNotes,
                                  onDeleteNote: (note) async {
                                    await _notesService.deleteNote(id: note.id);
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

// import 'package:flutter/material.dart';
// import 'package:mynotes/constants/routes.dart';
// import 'package:mynotes/services/auth/auth_service.dart';
// import 'package:mynotes/services/crud/notes_service.dart';

// import '../dialogs/logout_dialog.dart';
// import '../enums/menu_actions.dart';
// import 'notes_list_view.dart';

// class NotesView extends StatefulWidget {
//   const NotesView({Key? key}) : super(key: key);

//   @override
//   State<NotesView> createState() => _NotesViewState();
// }

// class _NotesViewState extends State<NotesView> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentUser!.email!;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Notes'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(newNoteRoute);
//             },
//             icon: const Icon(Icons.add),
//           ),
//           PopupMenuButton<MenuAction>(
//             onSelected: (value) async {
//               switch (value) {
//                 case MenuAction.logout:
//                   final shouldLogout = await showLogOutDialog(context);
//                   if (shouldLogout) {
//                     await AuthService.firebase().logOut();
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                       loginRoute,
//                       (_) => false,
//                     );
//                   }
//               }
//             },
//             itemBuilder: (context) {
//               return const [
//                 PopupMenuItem<MenuAction>(
//                   value: MenuAction.logout,
//                   child: Text('Log out'),
//                 ),
//               ];
//             },
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                 stream: _notesService.allNotes,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                     case ConnectionState.active:
//                       if (snapshot.hasData) {
//                         final allNotes = snapshot.data as List<DatabaseNote>;
//                         return NotesListView(
//                           notes: allNotes,
//                           onDeleteNote: (note) async {
//                             await _notesService.deleteNote(id: note.id);
//                           },
//                         );
//                       } else {
//                         return const CircularProgressIndicator();
//                       }
//                     default:
//                       return const CircularProgressIndicator();
//                   }
//                 },
//               );
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }

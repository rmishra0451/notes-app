import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import '../../constants/db_constants.dart';
import 'db_exceptions.dart';

class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    //getAllNotes returns an Iterable but function wants a list, so convert to list or return Iterable from function
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = await _getDatabaseOrThrow();
    final deletedCount = await db
        .delete(userTable, where: 'email= ?', whereArgs: [email.toLowerCase()]);

    if (deletedCount == 0) {
      throw CouldNotDeleteUser();
    } else if (deletedCount > 1) {
      throw DeletedMoreThanOneUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email= ?', whereArgs: [email.toLowerCase()]);

    if (result.isNotEmpty) {
      throw EmailAlreadyInUseAuthException();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

//For Debugging
  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on EmailAlreadyInUseAuthException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable, where: 'email: ?', whereArgs: [
      {email.toLowerCase()}
    ]);
    if (result.isEmpty) {
      throw UserNotFoundAuthException();
    }

    return DatabaseUser.fromRow(result.first);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw UserNotFoundAuthException();
    }

    const text = '';

    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedColumn: 1,
    });

    final note =
        DatabaseNote(id: noteId, userId: owner.id, text: text, isSynced: true);

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes =
        await db.query(noteTable, limit: 1, where: 'id= ?', whereArgs: [id]);

    if (notes.isEmpty) {
      throw NoteNotFound();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    if (notes.isEmpty) {
      throw NoteNotFound();
    }

    return notes.map((n) => DatabaseNote.fromRow(n));
  }

  Future<Iterable<DatabaseNote>> getUsersNotes({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes =
        await db.query(noteTable, where: 'user_id= ?', whereArgs: [id]);

    return notes.map((n) => DatabaseNote.fromRow(n));
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbNote =
        await db.query(noteTable, where: 'id= ?', whereArgs: [note.id]);

    if (dbNote.isEmpty) {
      throw NoteNotFound();
    }

    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(noteTable, where: 'id= ?', whereArgs: [id]);

    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<void> deleteAllNotesForUser({required int userId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final user = await db.query(userTable, where: 'id= ?', whereArgs: [userId]);
    if (user.isNotEmpty) {
      await db.delete(noteTable, where: 'user_id: ?', whereArgs: [userId]);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() {
    return 'User, ID= $id and Email= $email';
  }

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynced;

  const DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSynced});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynced = (map[isSyncedColumn] as int) == 1 ? true : false;

  @override
  String toString() => 'Note, ID= $id. UserID= $userId, Synced= $isSynced';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

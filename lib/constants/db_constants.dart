const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedColumn = 'is_synced';

const dbName = 'notes.db';
const userTable = 'user';
const noteTable = 'note';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
                              	"id"	INTEGER,
                              	"email"	INTEGER UNIQUE,
                              	PRIMARY KEY("id" AUTOINCREMENT)
                              );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
                              	"id"	INTEGER COLLATE UTF16CI,
                              	"user_id"	INTEGER,
                              	"text"	TEXT,
                              	"is_synced"	INTEGER NOT NULL DEFAULT 0,
                              	FOREIGN KEY("user_id") REFERENCES "user"("id"),
                              	PRIMARY KEY("id" AUTOINCREMENT)
                              );''';

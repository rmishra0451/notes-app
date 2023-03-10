const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedColumn = 'is_synced';

const dbName = 'my-notes.db';
const userTable = 'user';
const noteTable = 'note';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
                              	"id"	INTEGER NOT NULL,
                              	"email"	INTEGER NOT NULL UNIQUE,
                              	PRIMARY KEY("id" AUTOINCREMENT)
                              );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
                              	"id"	INTEGER NOT NULL,
                              	"user_id"	INTEGER NOT NULL,
                              	"text"	TEXT,
                              	"is_synced"	INTEGER NOT NULL DEFAULT 0,
                              	FOREIGN KEY("user_id") REFERENCES "user"("id"),
                              	PRIMARY KEY("id" AUTOINCREMENT)
                              );''';

// Cloud constants
const ownerUserIdFieldName = 'user_id';
const textFieldName = 'text';

/// SQL schema definitions for the local SQLite database.
class Schema {
  Schema._();

  // ─── Table Names ─────────────────────────────────────
  static const String usersTable = 'users';
  static const String eventsTable = 'events';
  static const String registrationsTable = 'registrations';
  static const String timetableTable = 'timetable';

  // ─── Create Statements ──────────────────────────────
  static const String createUsersTable = '''
    CREATE TABLE $usersTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'student',
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )
  ''';

  static const String createEventsTable = '''
    CREATE TABLE $eventsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      date TEXT NOT NULL,
      location TEXT NOT NULL,
      capacity INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const String createRegistrationsTable = '''
    CREATE TABLE $registrationsTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      event_id INTEGER NOT NULL,
      qr_code TEXT NOT NULL,
      registered_at TEXT NOT NULL DEFAULT (datetime('now')),
      FOREIGN KEY (user_id) REFERENCES $usersTable(id) ON DELETE CASCADE,
      FOREIGN KEY (event_id) REFERENCES $eventsTable(id) ON DELETE CASCADE
    )
  ''';

  static const String createTimetableTable = '''
    CREATE TABLE $timetableTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject TEXT NOT NULL,
      instructor TEXT NOT NULL,
      day TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      room TEXT NOT NULL,
      color INTEGER NOT NULL DEFAULT 0xFF6C63FF
    )
  ''';

  /// All create-table statements in dependency order.
  static List<String> get allCreateStatements => [
    createUsersTable,
    createEventsTable,
    createRegistrationsTable,
    createTimetableTable,
  ];
}

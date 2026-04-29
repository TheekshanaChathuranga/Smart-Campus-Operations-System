import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';

/// Singleton helper for SQLite database initialization and access.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  static const String _dbName = 'smart_campus.db';
  static const int _dbVersion = 1;

  /// Returns the database instance, initializing if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Enable foreign keys.
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create all tables.
  Future<void> _onCreate(Database db, int version) async {
    for (final sql in Schema.allCreateStatements) {
      await db.execute(sql);
    }
    // Insert sample data for demonstration
    await _insertSampleData(db);
  }

  /// Handle migrations.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations go here
  }

  /// Insert sample data so the app works out of the box.
  Future<void> _insertSampleData(Database db) async {
    // Sample users
    await db.insert(Schema.usersTable, {
      'name': 'John Student',
      'email': 'student@campus.edu',
      'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // "password"
      'role': 'student',
    });
    await db.insert(Schema.usersTable, {
      'name': 'Dr. Jane Smith',
      'email': 'staff@campus.edu',
      'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // "password"
      'role': 'staff',
    });

    // Sample events
    await db.insert(Schema.eventsTable, {
      'title': 'Tech Innovation Summit 2026',
      'description': 'Join us for a day of cutting-edge technology showcases, keynote speakers from industry leaders, and hands-on workshops covering AI, IoT, and sustainable tech.',
      'date': '2026-05-15 09:00:00',
      'location': 'Main Auditorium, Block A',
      'capacity': 200,
    });
    await db.insert(Schema.eventsTable, {
      'title': 'Annual Sports Fest',
      'description': 'A week-long celebration of athletics featuring inter-departmental competitions in cricket, football, basketball, athletics, and more.',
      'date': '2026-05-20 07:00:00',
      'location': 'University Sports Complex',
      'capacity': 500,
    });
    await db.insert(Schema.eventsTable, {
      'title': 'Cultural Night',
      'description': 'An evening of music, dance, drama, and art showcasing the diverse talents of our campus community. Open to all students and families.',
      'date': '2026-06-01 18:00:00',
      'location': 'Open Air Theatre',
      'capacity': 300,
    });
    await db.insert(Schema.eventsTable, {
      'title': 'Research Paper Workshop',
      'description': 'Learn the fundamentals of academic writing, citation formats, and publishing strategies with guidance from experienced faculty members.',
      'date': '2026-06-10 10:00:00',
      'location': 'Library Seminar Hall',
      'capacity': 50,
    });
    await db.insert(Schema.eventsTable, {
      'title': 'Startup Pitch Competition',
      'description': 'Present your startup ideas to a panel of venture capitalists and industry mentors. Top 3 teams win seed funding and incubation support.',
      'date': '2026-06-18 14:00:00',
      'location': 'Innovation Center, 3rd Floor',
      'capacity': 100,
    });

    // Sample timetable entries
    final timetableData = [
      {'subject': 'Data Structures & Algorithms', 'instructor': 'Dr. Patel', 'day': 'Monday', 'start_time': '09:00', 'end_time': '10:30', 'room': 'CS-201', 'color': 0xFF6C63FF},
      {'subject': 'Operating Systems', 'instructor': 'Prof. Kumar', 'day': 'Monday', 'start_time': '11:00', 'end_time': '12:30', 'room': 'CS-305', 'color': 0xFF03DAC6},
      {'subject': 'Database Management', 'instructor': 'Dr. Singh', 'day': 'Monday', 'start_time': '14:00', 'end_time': '15:30', 'room': 'CS-102', 'color': 0xFFFF6584},
      {'subject': 'Computer Networks', 'instructor': 'Prof. Gupta', 'day': 'Tuesday', 'start_time': '09:00', 'end_time': '10:30', 'room': 'CS-401', 'color': 0xFFFFB74D},
      {'subject': 'Software Engineering', 'instructor': 'Dr. Sharma', 'day': 'Tuesday', 'start_time': '11:00', 'end_time': '12:30', 'room': 'CS-203', 'color': 0xFF4FC3F7},
      {'subject': 'Data Structures & Algorithms', 'instructor': 'Dr. Patel', 'day': 'Wednesday', 'start_time': '09:00', 'end_time': '10:30', 'room': 'CS-201', 'color': 0xFF6C63FF},
      {'subject': 'Machine Learning', 'instructor': 'Dr. Reddy', 'day': 'Wednesday', 'start_time': '14:00', 'end_time': '16:00', 'room': 'AI Lab', 'color': 0xFFAB47BC},
      {'subject': 'Operating Systems', 'instructor': 'Prof. Kumar', 'day': 'Thursday', 'start_time': '09:00', 'end_time': '10:30', 'room': 'CS-305', 'color': 0xFF03DAC6},
      {'subject': 'Computer Networks', 'instructor': 'Prof. Gupta', 'day': 'Thursday', 'start_time': '11:00', 'end_time': '12:30', 'room': 'CS-401', 'color': 0xFFFFB74D},
      {'subject': 'Database Management', 'instructor': 'Dr. Singh', 'day': 'Friday', 'start_time': '09:00', 'end_time': '10:30', 'room': 'CS-102', 'color': 0xFFFF6584},
      {'subject': 'Software Engineering', 'instructor': 'Dr. Sharma', 'day': 'Friday', 'start_time': '14:00', 'end_time': '15:30', 'room': 'CS-203', 'color': 0xFF4FC3F7},
    ];
    for (final entry in timetableData) {
      await db.insert(Schema.timetableTable, entry);
    }
  }

  /// Close the database connection.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

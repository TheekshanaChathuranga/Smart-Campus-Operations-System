import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/events/data/models/event_model.dart';
import 'package:smart_campus_operations_system/features/events/data/models/registration_model.dart';

/// Local data source for events and registrations using SQLite.
class EventLocalDataSource {
  final DatabaseHelper _dbHelper;

  EventLocalDataSource(this._dbHelper);

  // ─── Events ────────────────────────────────────────

  /// Get all events with registration count.
  Future<List<EventModel>> getAllEvents() async {
    try {
      final db = await _dbHelper.database;
      final results = await db.rawQuery('''
        SELECT e.*,
          (SELECT COUNT(*) FROM ${Schema.registrationsTable} r WHERE r.event_id = e.id) as registered_count
        FROM ${Schema.eventsTable} e
        ORDER BY e.date ASC
      ''');
      return results.map((map) => EventModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch events: $e');
    }
  }

  /// Get a single event by ID with registration count.
  Future<EventModel?> getEventById(int id) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.rawQuery('''
        SELECT e.*,
          (SELECT COUNT(*) FROM ${Schema.registrationsTable} r WHERE r.event_id = e.id) as registered_count
        FROM ${Schema.eventsTable} e
        WHERE e.id = ?
      ''', [id]);
      if (results.isEmpty) return null;
      return EventModel.fromMap(results.first);
    } catch (e) {
      throw DatabaseException('Failed to fetch event: $e');
    }
  }

  /// Insert a new event (staff only).
  Future<int> insertEvent(Map<String, dynamic> data) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(Schema.eventsTable, data);
    } catch (e) {
      throw DatabaseException('Failed to create event: $e');
    }
  }

  /// Update an existing event (staff only).
  Future<void> updateEvent(int id, Map<String, dynamic> data) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        Schema.eventsTable,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to update event: $e');
    }
  }

  /// Delete an event by ID (staff only).
  Future<void> deleteEvent(int id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(Schema.eventsTable, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DatabaseException('Failed to delete event: $e');
    }
  }

  // ─── Registrations ─────────────────────────────────

  /// Register a user for an event.
  Future<int> registerForEvent(Map<String, dynamic> data) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(Schema.registrationsTable, data);
    } catch (e) {
      throw DatabaseException('Failed to register for event: $e');
    }
  }

  /// Check if a user is already registered for an event.
  Future<RegistrationModel?> getRegistration(int userId, int eventId) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.registrationsTable,
        where: 'user_id = ? AND event_id = ?',
        whereArgs: [userId, eventId],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return RegistrationModel.fromMap(results.first);
    } catch (e) {
      throw DatabaseException('Failed to check registration: $e');
    }
  }

  /// Get all registrations for a user.
  Future<List<RegistrationModel>> getUserRegistrations(int userId) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.registrationsTable,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'registered_at DESC',
      );
      return results.map((map) => RegistrationModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch registrations: $e');
    }
  }

  // ─── QR Check-in (Staff) ───────────────────────────

  /// Fetch a registration record with joined student name and event title.
  Future<Map<String, dynamic>?> getRegistrationByQrCode(String qrCode) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.rawQuery('''
        SELECT r.*, u.name as student_name, e.title as event_title
        FROM ${Schema.registrationsTable} r
        JOIN ${Schema.usersTable} u ON r.user_id = u.id
        JOIN ${Schema.eventsTable} e ON r.event_id = e.id
        WHERE r.qr_code = ?
      ''', [qrCode]);
      if (results.isEmpty) return null;
      return results.first;
    } catch (e) {
      throw DatabaseException('Failed to look up QR code: $e');
    }
  }

  /// Mark a registration as attended.
  Future<void> markAttended(String qrCode) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        Schema.registrationsTable,
        {'status': 'attended'},
        where: 'qr_code = ?',
        whereArgs: [qrCode],
      );
    } catch (e) {
      throw DatabaseException('Failed to mark attendance: $e');
    }
  }
}

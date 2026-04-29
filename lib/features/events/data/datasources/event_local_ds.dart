import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/events/data/models/event_model.dart';
import 'package:smart_campus_operations_system/features/events/data/models/registration_model.dart';

/// Local data source for events and registrations using SQLite.
class EventLocalDataSource {
  final DatabaseHelper _dbHelper;

  EventLocalDataSource(this._dbHelper);

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
}

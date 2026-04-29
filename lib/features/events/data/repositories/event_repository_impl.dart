import 'package:uuid/uuid.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/events/data/datasources/event_local_ds.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/check_in_result.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';

/// Concrete implementation of [IEventRepository].
class EventRepositoryImpl implements IEventRepository {
  final EventLocalDataSource _localDataSource;
  final _uuid = const Uuid();

  EventRepositoryImpl(this._localDataSource);

  // ─── Read ──────────────────────────────────────────

  @override
  Future<List<Event>> getAllEvents() async {
    final models = await _localDataSource.getAllEvents();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Event?> getEventById(int id) async {
    final model = await _localDataSource.getEventById(id);
    return model?.toEntity();
  }

  @override
  Future<Registration?> getRegistration(int userId, int eventId) async {
    final model = await _localDataSource.getRegistration(userId, eventId);
    return model?.toEntity();
  }

  @override
  Future<List<Registration>> getUserRegistrations(int userId) async {
    final models = await _localDataSource.getUserRegistrations(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  // ─── Student Registration ──────────────────────────

  @override
  Future<Registration> registerForEvent(int userId, int eventId) async {
    final qrCode = _uuid.v4();
    final id = await _localDataSource.registerForEvent({
      'user_id': userId,
      'event_id': eventId,
      'qr_code': qrCode,
    });

    return Registration(
      id: id,
      userId: userId,
      eventId: eventId,
      qrCode: qrCode,
      registeredAt: DateTime.now(),
    );
  }

  // ─── Staff: Event CRUD ─────────────────────────────

  @override
  Future<Event> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  }) async {
    final id = await _localDataSource.insertEvent({
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'capacity': capacity,
    });
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      location: location,
      capacity: capacity,
    );
  }

  @override
  Future<void> updateEvent(
    int id, {
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  }) async {
    await _localDataSource.updateEvent(id, {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'capacity': capacity,
    });
  }

  @override
  Future<void> deleteEvent(int id) async {
    await _localDataSource.deleteEvent(id);
  }

  // ─── Staff: QR Check-in ────────────────────────────

  @override
  Future<CheckInResult> verifyQrCode(String qrCode) async {
    final row = await _localDataSource.getRegistrationByQrCode(qrCode);
    if (row == null) {
      throw const AppException('Invalid QR code — no matching registration found.');
    }
    if ((row['status'] as String?) == 'attended') {
      throw const AppException('This ticket has already been used for check-in.');
    }
    await _localDataSource.markAttended(qrCode);
    return CheckInResult(
      studentName: row['student_name'] as String,
      eventTitle: row['event_title'] as String,
      qrCode: qrCode,
      registeredAt: DateTime.tryParse(row['registered_at'] as String) ?? DateTime.now(),
    );
  }
}

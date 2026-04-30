import 'package:smart_campus_operations_system/features/events/domain/entities/check_in_result.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';

/// Abstract interface for event repository.
abstract class IEventRepository {
  // ─── Read ──────────────────────────────────────────
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(int id);
  Future<Registration?> getRegistration(int userId, int eventId);
  Future<List<Registration>> getUserRegistrations(int userId);

  // ─── Student Registration ──────────────────────────
  Future<Registration> registerForEvent(int userId, int eventId);

  // ─── Staff: Event CRUD ─────────────────────────────
  Future<Event> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  });

  Future<void> updateEvent(
    int id, {
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  });

  Future<void> deleteEvent(int id);

  // ─── Staff: QR Check-in ────────────────────────────
  Future<CheckInResult> verifyQrCode(String qrCode);
}

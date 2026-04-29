import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';

/// Abstract interface for event repository.
abstract class IEventRepository {
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(int id);
  Future<Registration> registerForEvent(int userId, int eventId);
  Future<Registration?> getRegistration(int userId, int eventId);
  Future<List<Registration>> getUserRegistrations(int userId);
}

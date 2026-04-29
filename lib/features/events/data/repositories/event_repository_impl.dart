import 'package:uuid/uuid.dart';
import 'package:smart_campus_operations_system/features/events/data/datasources/event_local_ds.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';

/// Concrete implementation of [IEventRepository].
class EventRepositoryImpl implements IEventRepository {
  final EventLocalDataSource _localDataSource;
  final _uuid = const Uuid();

  EventRepositoryImpl(this._localDataSource);

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
}

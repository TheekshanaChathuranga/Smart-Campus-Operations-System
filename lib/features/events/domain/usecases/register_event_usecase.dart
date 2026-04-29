import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';

/// Use case to register for an event.
class RegisterEventUseCase {
  final IEventRepository _repository;

  const RegisterEventUseCase(this._repository);

  Future<Registration> call(int userId, int eventId) {
    return _repository.registerForEvent(userId, eventId);
  }
}

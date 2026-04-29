import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/repositories/i_announcement_repository.dart';

/// Use case to get all announcements.
class GetAnnouncementsUseCase {
  final IAnnouncementRepository _repository;

  const GetAnnouncementsUseCase(this._repository);

  Future<List<Announcement>> call() {
    return _repository.getAnnouncements();
  }
}

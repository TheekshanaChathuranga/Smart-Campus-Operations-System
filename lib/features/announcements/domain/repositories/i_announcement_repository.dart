import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';

/// Abstract interface for announcement repository.
abstract class IAnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();

  Future<void> postAnnouncement({
    required String title,
    required String body,
    required String category,
    required int authorId,
    bool isUrgent = false,
  });
}

import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';

/// Abstract interface for announcements repository.
abstract class IAnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();
}

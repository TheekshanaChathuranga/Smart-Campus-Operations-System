import 'package:smart_campus_operations_system/features/announcements/data/datasources/announcement_local_ds.dart';
import 'package:smart_campus_operations_system/features/announcements/data/datasources/announcement_remote_ds.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/repositories/i_announcement_repository.dart';
import 'package:smart_campus_operations_system/features/notifications/notification_service.dart';

/// Concrete implementation of [IAnnouncementRepository].
/// Merges locally-stored (staff-posted) and remote (API/mock) announcements.
class AnnouncementRepositoryImpl implements IAnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;
  final AnnouncementLocalDataSource _localDataSource;

  AnnouncementRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final remoteModels = await _remoteDataSource.getAnnouncements();
    final localModels = await _localDataSource.getLocalAnnouncements();

    // Local (staff-posted) announcements appear at the top, newest first.
    final local = localModels.map((m) => m.toEntity()).toList();
    final remote = remoteModels.map((m) => m.toEntity()).toList();
    return [...local, ...remote];
  }

  @override
  Future<void> postAnnouncement({
    required String title,
    required String body,
    required String category,
    required int authorId,
    bool isUrgent = false,
  }) async {
    await _localDataSource.insertAnnouncement({
      'title': title,
      'body': body,
      'category': category,
      'author_id': authorId,
      'published_at': DateTime.now().toIso8601String(),
    });

    if (isUrgent) {
      await NotificationService().sendPushNotification(
        title,
        body,
        topic: 'all_users',
      );
    }
  }
}


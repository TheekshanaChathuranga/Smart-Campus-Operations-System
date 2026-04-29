import 'package:smart_campus_operations_system/features/announcements/data/datasources/announcement_remote_ds.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/repositories/i_announcement_repository.dart';

/// Concrete implementation of [IAnnouncementRepository].
class AnnouncementRepositoryImpl implements IAnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;

  AnnouncementRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final models = await _remoteDataSource.getAnnouncements();
    return models.map((m) => m.toEntity()).toList();
  }
}

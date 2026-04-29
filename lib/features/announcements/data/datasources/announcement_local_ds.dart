import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/announcements/data/models/announcement_model.dart';

/// Local SQLite datasource for staff-posted announcements.
class AnnouncementLocalDataSource {
  final DatabaseHelper _dbHelper;

  AnnouncementLocalDataSource(this._dbHelper);

  /// Insert a new staff-posted announcement.
  Future<int> insertAnnouncement(Map<String, dynamic> data) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(Schema.announcementsTable, data);
    } catch (e) {
      throw DatabaseException('Failed to save announcement: $e');
    }
  }

  /// Fetch all locally-stored announcements, newest first.
  Future<List<AnnouncementModel>> getLocalAnnouncements() async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.announcementsTable,
        orderBy: 'published_at DESC',
      );
      return results.map((map) => AnnouncementModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch local announcements: $e');
    }
  }
}

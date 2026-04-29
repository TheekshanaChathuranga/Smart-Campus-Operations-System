import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/timetable/data/models/timetable_model.dart';

/// Local data source for timetable CRUD using SQLite.
class TimetableLocalDataSource {
  final DatabaseHelper _dbHelper;

  TimetableLocalDataSource(this._dbHelper);

  Future<List<TimetableModel>> getScheduleByDay(String day) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.timetableTable,
        where: 'day = ?',
        whereArgs: [day],
        orderBy: 'start_time ASC',
      );
      return results.map((map) => TimetableModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch timetable: $e');
    }
  }

  Future<List<TimetableModel>> getAllSchedule() async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.timetableTable,
        orderBy: "CASE day "
            "WHEN 'Monday' THEN 1 "
            "WHEN 'Tuesday' THEN 2 "
            "WHEN 'Wednesday' THEN 3 "
            "WHEN 'Thursday' THEN 4 "
            "WHEN 'Friday' THEN 5 "
            "WHEN 'Saturday' THEN 6 "
            "WHEN 'Sunday' THEN 7 END, start_time ASC",
      );
      return results.map((map) => TimetableModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to fetch timetable: $e');
    }
  }

  Future<int> insertEntry(Map<String, dynamic> data) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(Schema.timetableTable, data);
    } catch (e) {
      throw DatabaseException('Failed to insert timetable entry: $e');
    }
  }

  Future<int> deleteEntry(int id) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        Schema.timetableTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseException('Failed to delete timetable entry: $e');
    }
  }
}

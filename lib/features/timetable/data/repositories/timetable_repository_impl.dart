import 'package:smart_campus_operations_system/features/timetable/data/datasources/timetable_local_ds.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/repositories/i_timetable_repository.dart';

/// Concrete implementation of [ITimetableRepository].
class TimetableRepositoryImpl implements ITimetableRepository {
  final TimetableLocalDataSource _localDataSource;

  TimetableRepositoryImpl(this._localDataSource);

  @override
  Future<List<ScheduleEntry>> getScheduleByDay(String day) async {
    final models = await _localDataSource.getScheduleByDay(day);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ScheduleEntry>> getAllSchedule() async {
    final models = await _localDataSource.getAllSchedule();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createSchedule({
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
    int color = 0xFF6C63FF,
  }) async {
    await _localDataSource.insertEntry({
      'subject': subject,
      'instructor': instructor,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'color': color,
    });
  }

  @override
  Future<void> updateSchedule(
    int id, {
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
    int color = 0xFF6C63FF,
  }) async {
    await _localDataSource.updateEntry(id, {
      'subject': subject,
      'instructor': instructor,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'color': color,
    });
  }

  @override
  Future<void> deleteSchedule(int id) async {
    await _localDataSource.deleteEntry(id);
  }
}

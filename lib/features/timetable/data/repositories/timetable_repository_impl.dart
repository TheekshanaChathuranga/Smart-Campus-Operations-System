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
}

import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';

/// Abstract interface for timetable repository.
abstract class ITimetableRepository {
  Future<List<ScheduleEntry>> getScheduleByDay(String day);
  Future<List<ScheduleEntry>> getAllSchedule();
}

import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';

/// Abstract interface for timetable repository.
abstract class ITimetableRepository {
  Future<List<ScheduleEntry>> getScheduleByDay(String day);
  Future<List<ScheduleEntry>> getAllSchedule();

  Future<void> createSchedule({
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
    int color = 0xFF6C63FF,
  });

  Future<void> updateSchedule(
    int id, {
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
    int color = 0xFF6C63FF,
  });

  Future<void> deleteSchedule(int id);
}

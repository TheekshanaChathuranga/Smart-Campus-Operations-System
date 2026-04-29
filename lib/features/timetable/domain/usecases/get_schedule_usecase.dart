import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/repositories/i_timetable_repository.dart';

/// Use case to get the schedule for a specific day or all days.
class GetScheduleUseCase {
  final ITimetableRepository _repository;

  const GetScheduleUseCase(this._repository);

  Future<List<ScheduleEntry>> call(String day) {
    return _repository.getScheduleByDay(day);
  }

  Future<List<ScheduleEntry>> allDays() {
    return _repository.getAllSchedule();
  }
}

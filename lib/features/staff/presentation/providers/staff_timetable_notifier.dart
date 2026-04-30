import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/repositories/i_timetable_repository.dart';

class StaffTimetableState {
  final List<ScheduleEntry> schedule;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const StaffTimetableState({
    this.schedule = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  StaffTimetableState copyWith({
    List<ScheduleEntry>? schedule,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return StaffTimetableState(
      schedule: schedule ?? this.schedule,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class StaffTimetableNotifier extends StateNotifier<StaffTimetableState> {
  final ITimetableRepository _repository;

  StaffTimetableNotifier(this._repository) : super(const StaffTimetableState());

  Future<void> loadAllSchedule() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final entries = await _repository.getAllSchedule();
      state = state.copyWith(schedule: entries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createSchedule({
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.createSchedule(
        subject: subject,
        instructor: instructor,
        day: day,
        startTime: startTime,
        endTime: endTime,
        room: room,
      );
      await loadAllSchedule();
      state = state.copyWith(successMessage: 'Timetable entry created successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateSchedule(
    int id, {
    required String subject,
    required String instructor,
    required String day,
    required String startTime,
    required String endTime,
    required String room,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.updateSchedule(
        id,
        subject: subject,
        instructor: instructor,
        day: day,
        startTime: startTime,
        endTime: endTime,
        room: room,
      );
      await loadAllSchedule();
      state = state.copyWith(successMessage: 'Timetable entry updated successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteSchedule(int id) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.deleteSchedule(id);
      await loadAllSchedule();
      state = state.copyWith(successMessage: 'Timetable entry deleted.');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() => state = state.copyWith(clearError: true, clearSuccess: true);
}

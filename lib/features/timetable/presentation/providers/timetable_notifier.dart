import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/usecases/get_schedule_usecase.dart';

/// State for timetable.
class TimetableState {
  final List<ScheduleEntry> entries;
  final bool isLoading;
  final String? error;
  final String selectedDay;

  const TimetableState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.selectedDay = 'Monday',
  });

  TimetableState copyWith({
    List<ScheduleEntry>? entries,
    bool? isLoading,
    String? error,
    String? selectedDay,
    bool clearError = false,
  }) {
    return TimetableState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

/// StateNotifier for timetable management.
class TimetableNotifier extends StateNotifier<TimetableState> {
  final GetScheduleUseCase _getScheduleUseCase;

  TimetableNotifier(this._getScheduleUseCase) : super(const TimetableState());

  /// Load schedule for a specific day.
  Future<void> loadSchedule(String day) async {
    state = state.copyWith(isLoading: true, selectedDay: day, clearError: true);
    try {
      final entries = await _getScheduleUseCase(day);
      state = state.copyWith(entries: entries, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Select a day and load its schedule.
  Future<void> selectDay(String day) async {
    await loadSchedule(day);
  }
}

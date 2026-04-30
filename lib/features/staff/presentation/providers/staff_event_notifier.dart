import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';


class StaffEventState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const StaffEventState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  StaffEventState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return StaffEventState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class StaffEventNotifier extends StateNotifier<StaffEventState> {
  final IEventRepository _repository;
  final Ref _ref;

  StaffEventNotifier(this._repository, this._ref) : super(const StaffEventState());

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.createEvent(
        title: title,
        description: description,
        date: date,
        location: location,
        capacity: capacity,
      );
      _ref.read(eventNotifierProvider.notifier).loadEvents();
      state = state.copyWith(isLoading: false, successMessage: 'Event created successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEvent(
    int id, {
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int capacity,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.updateEvent(
        id,
        title: title,
        description: description,
        date: date,
        location: location,
        capacity: capacity,
      );
      _ref.read(eventNotifierProvider.notifier).loadEvents();
      state = state.copyWith(isLoading: false, successMessage: 'Event updated successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteEvent(int id) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.deleteEvent(id);
      _ref.read(eventNotifierProvider.notifier).loadEvents();
      state = state.copyWith(isLoading: false, successMessage: 'Event deleted.');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() => state = state.copyWith(clearError: true, clearSuccess: true);
}

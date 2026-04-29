import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';
import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';

/// State for events feature.
class EventState {
  final List<Event> events;
  final Event? selectedEvent;
  final Registration? currentRegistration;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const EventState({
    this.events = const [],
    this.selectedEvent,
    this.currentRegistration,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  EventState copyWith({
    List<Event>? events,
    Event? selectedEvent,
    Registration? currentRegistration,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearRegistration = false,
  }) {
    return EventState(
      events: events ?? this.events,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      currentRegistration: clearRegistration ? null : (currentRegistration ?? this.currentRegistration),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

/// StateNotifier for event management.
class EventNotifier extends StateNotifier<EventState> {
  final IEventRepository _repository;

  EventNotifier(this._repository) : super(const EventState());

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final events = await _repository.getAllEvents();
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadEvent(int eventId) async {
    state = state.copyWith(isLoading: true, clearError: true, clearRegistration: true);
    try {
      final event = await _repository.getEventById(eventId);
      state = state.copyWith(selectedEvent: event, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkRegistration(int userId, int eventId) async {
    try {
      final registration = await _repository.getRegistration(userId, eventId);
      state = state.copyWith(currentRegistration: registration);
    } catch (_) {
      // Silently ignore — not registered
    }
  }

  Future<void> registerForEvent(int userId, int eventId) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      final registration = await _repository.registerForEvent(userId, eventId);
      // Reload event to update count
      final event = await _repository.getEventById(eventId);
      state = state.copyWith(
        currentRegistration: registration,
        selectedEvent: event,
        isLoading: false,
        successMessage: 'Successfully registered! Your QR code is ready.',
      );
      // Also reload all events
      loadEvents();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

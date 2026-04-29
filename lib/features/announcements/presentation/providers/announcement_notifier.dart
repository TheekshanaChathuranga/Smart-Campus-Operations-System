import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/usecases/get_announcements_usecase.dart';

/// State for announcements.
class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? error;

  const AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// StateNotifier for announcements.
class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  final GetAnnouncementsUseCase _getAnnouncementsUseCase;

  AnnouncementNotifier(this._getAnnouncementsUseCase)
      : super(const AnnouncementState());

  Future<void> loadAnnouncements() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final announcements = await _getAnnouncementsUseCase();
      state = state.copyWith(announcements: announcements, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

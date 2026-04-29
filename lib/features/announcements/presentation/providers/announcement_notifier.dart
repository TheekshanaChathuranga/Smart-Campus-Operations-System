import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/repositories/i_announcement_repository.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/usecases/get_announcements_usecase.dart';

/// State for announcements.
class AnnouncementState {
  final List<Announcement> announcements;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

/// StateNotifier for announcements.
class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  final GetAnnouncementsUseCase _getAnnouncementsUseCase;
  final IAnnouncementRepository _repository;

  AnnouncementNotifier(this._getAnnouncementsUseCase, this._repository)
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

  Future<void> postAnnouncement({
    required String title,
    required String body,
    required String category,
    required int authorId,
    bool isUrgent = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    try {
      await _repository.postAnnouncement(
        title: title,
        body: body,
        category: category,
        authorId: authorId,
        isUrgent: isUrgent,
      );
      // Reload so the new announcement appears at top.
      await loadAnnouncements();
      state = state.copyWith(successMessage: 'Announcement posted successfully!');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMessages() => state = state.copyWith(clearError: true, clearSuccess: true);
}

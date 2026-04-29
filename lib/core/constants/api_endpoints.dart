/// Centralized API endpoint constants.
class ApiEndpoints {
  ApiEndpoints._();

  // ─── Base URL ────────────────────────────────────────
  static const String baseUrl = 'https://api.smartcampus.edu/v1';

  // ─── Auth ────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // ─── Timetable ───────────────────────────────────────
  static const String timetable = '/timetable';
  static String timetableByDay(String day) => '/timetable?day=$day';

  // ─── Events ──────────────────────────────────────────
  static const String events = '/events';
  static String eventById(String id) => '/events/$id';
  static const String registrations = '/registrations';
  static String registerEvent(String eventId) => '/events/$eventId/register';

  // ─── Announcements ──────────────────────────────────
  static const String announcements = '/announcements';
  static String announcementById(String id) => '/announcements/$id';

  // ─── Notifications ──────────────────────────────────
  static const String registerFcmToken = '/notifications/register-token';

  // ─── Campus Map ─────────────────────────────────────
  static const String campusLocations = '/campus/locations';
}

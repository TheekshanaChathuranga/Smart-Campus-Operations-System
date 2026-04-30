/// Centralized UI string constants.
class AppStrings {
  AppStrings._();

  // ─── App ─────────────────────────────────────────────
  static const String appName = 'CampusFlow';
  static const String appTagline =
      'University of Ruhuna, Faculty of Technology.';

  // ─── Auth ────────────────────────────────────────────
  static const String login = 'Log In';
  static const String register = 'Create Account';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String selectRole = 'Select Role';
  static const String student = 'Student';
  static const String staff = 'Staff';
  static const String noAccount = "Don't have an account?";
  static const String hasAccount = 'Already have an account?';
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully!';
  static const String logoutConfirm = 'Are you sure you want to log out?';
  static const String logout = 'Log Out';

  // ─── Navigation ──────────────────────────────────────
  static const String timetable = 'Timetable';
  static const String events = 'Events';
  static const String announcements = 'Announcements';
  static const String campusMap = 'Campus Map';

  // ─── Timetable ───────────────────────────────────────
  static const String noClasses = 'No classes scheduled for this day.';
  static const String today = 'Today';

  // ─── Events ──────────────────────────────────────────
  static const String eventDetails = 'Event Details';
  static const String registerForEvent = 'Register';
  static const String alreadyRegistered = 'Already Registered';
  static const String registrationSuccess = 'Successfully registered!';
  static const String noEvents = 'No events available.';
  static const String spotsLeft = 'spots left';
  static const String yourQrCode = 'Your QR Code';

  // ─── Announcements ──────────────────────────────────
  static const String noAnnouncements = 'No announcements yet.';
  static const String newAnnouncement = 'New';

  // ─── Campus Map ─────────────────────────────────────
  static const String locatingYou = 'Getting your location...';
  static const String locationError = 'Could not determine your location.';

  // ─── Errors ──────────────────────────────────────────
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String serverError = 'Server is not responding.';
  static const String retry = 'Retry';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/core/di/providers.dart';
import 'package:smart_campus_operations_system/core/router/route_guards.dart';
import 'package:smart_campus_operations_system/features/auth/presentation/pages/login_page.dart';
import 'package:smart_campus_operations_system/features/auth/presentation/pages/register_page.dart';
import 'package:smart_campus_operations_system/features/timetable/presentation/pages/timetable_page.dart';
import 'package:smart_campus_operations_system/features/events/presentation/pages/events_page.dart';
import 'package:smart_campus_operations_system/features/events/presentation/pages/event_detail_page.dart';
import 'package:smart_campus_operations_system/features/announcements/presentation/pages/announcements_page.dart';
import 'package:smart_campus_operations_system/features/campus_map/presentation/pages/campus_map_page.dart';
import 'package:smart_campus_operations_system/features/qr_scanner/presentation/pages/qr_scanner_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/staff_dashboard_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/staff_events_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/event_form_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/create_announcement_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/staff_timetable_page.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/pages/timetable_form_page.dart';
import 'package:smart_campus_operations_system/shared/widgets/campus_bottom_nav.dart';
import 'package:smart_campus_operations_system/features/staff/presentation/widgets/staff_bottom_nav.dart';

/// Named route constants.
class AppRoutes {
  // Student routes
  static const String login = 'login';
  static const String register = 'register';
  static const String timetable = 'timetable';
  static const String events = 'events';
  static const String eventDetail = 'event-detail';
  static const String announcements = 'announcements';
  static const String campusMap = 'campus-map';
  static const String qrScanner = 'qr-scanner';
  // Staff routes
  static const String staffDashboard = 'staff-dashboard';
  static const String staffEvents = 'staff-events';
  static const String staffEventCreate = 'staff-event-create';
  static const String staffEventEdit = 'staff-event-edit';
  static const String staffAnnouncementCreate = 'staff-announcement-create';
  static const String staffAnnouncements = 'staff-announcements';
  static const String staffMap = 'staff-map';
  static const String staffTimetable = 'staff-timetable';
  static const String staffTimetableCreate = 'staff-timetable-create';
  static const String staffTimetableEdit = 'staff-timetable-edit';
}

/// GoRouter configuration provider.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) => RouteGuards.globalRedirect(authState, state),
    routes: [
      // ─── Auth Routes ────────────────────────────────
      GoRoute(
        name: AppRoutes.login,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.register,
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // ─── Student Shell ──────────────────────────────
      ShellRoute(
        builder: (context, state, child) => CampusBottomNav(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.timetable,
            path: '/timetable',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TimetablePage()),
          ),
          GoRoute(
            name: AppRoutes.events,
            path: '/events',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: EventsPage()),
            routes: [
              GoRoute(
                name: AppRoutes.eventDetail,
                path: ':eventId',
                builder: (context, state) {
                  final eventId = int.parse(state.pathParameters['eventId']!);
                  return EventDetailPage(eventId: eventId);
                },
              ),
            ],
          ),
          GoRoute(
            name: AppRoutes.announcements,
            path: '/announcements',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AnnouncementsPage()),
          ),
          GoRoute(
            name: AppRoutes.campusMap,
            path: '/map',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CampusMapPage()),
          ),
        ],
      ),

      // ─── Staff Shell ─────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => StaffBottomNav(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.staffDashboard,
            path: '/staff/dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StaffDashboardPage()),
          ),
          GoRoute(
            name: AppRoutes.staffEvents,
            path: '/staff/events',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StaffEventsPage()),
          ),
          GoRoute(
            name: AppRoutes.staffAnnouncements,
            path: '/staff/announcements',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AnnouncementsPage()),
          ),
          GoRoute(
            name: AppRoutes.staffMap,
            path: '/staff/map',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CampusMapPage()),
          ),
        ],
      ),

      // ─── Standalone Routes ───────────────────────────
      GoRoute(
        name: AppRoutes.qrScanner,
        path: '/qr-scanner',
        builder: (context, state) {
          final isStaffMode = state.extra as bool? ?? false;
          return QrScannerPage(isStaffMode: isStaffMode);
        },
      ),
      GoRoute(
        name: AppRoutes.staffEventCreate,
        path: '/staff/events/create',
        builder: (context, state) => const EventFormPage(),
      ),
      GoRoute(
        name: AppRoutes.staffEventEdit,
        path: '/staff/events/edit/:eventId',
        builder: (context, state) {
          final eventId = int.parse(state.pathParameters['eventId']!);
          return EventFormPage(eventId: eventId);
        },
      ),
      GoRoute(
        name: AppRoutes.staffAnnouncementCreate,
        path: '/staff/announcements/create',
        builder: (context, state) => const CreateAnnouncementPage(),
      ),
      GoRoute(
        name: AppRoutes.staffTimetable,
        path: '/staff/timetable',
        builder: (context, state) => const StaffTimetablePage(),
      ),
      GoRoute(
        name: AppRoutes.staffTimetableCreate,
        path: '/staff/timetable/create',
        builder: (context, state) => const TimetableFormPage(),
      ),
      GoRoute(
        name: AppRoutes.staffTimetableEdit,
        path: '/staff/timetable/edit/:entryId',
        builder: (context, state) {
          final entryId = int.parse(state.pathParameters['entryId']!);
          return TimetableFormPage(entryId: entryId);
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.uri.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/timetable'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

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
import 'package:smart_campus_operations_system/shared/widgets/campus_bottom_nav.dart';

/// Named route constants.
class AppRoutes {
  static const String login = 'login';
  static const String register = 'register';
  static const String timetable = 'timetable';
  static const String events = 'events';
  static const String eventDetail = 'event-detail';
  static const String announcements = 'announcements';
  static const String campusMap = 'campus-map';
  static const String qrScanner = 'qr-scanner';
}

/// GoRouter configuration provider.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return RouteGuards.globalRedirect(authState, state);
    },
    routes: [
      // ─── Auth Routes (no shell) ──────────────────────
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

      // ─── Main Shell with Bottom Nav ──────────────────
      ShellRoute(
        builder: (context, state, child) {
          return CampusBottomNav(child: child);
        },
        routes: [
          GoRoute(
            name: AppRoutes.timetable,
            path: '/timetable',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TimetablePage(),
            ),
          ),
          GoRoute(
            name: AppRoutes.events,
            path: '/events',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EventsPage(),
            ),
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
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnnouncementsPage(),
            ),
          ),
          GoRoute(
            name: AppRoutes.campusMap,
            path: '/map',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CampusMapPage(),
            ),
          ),
        ],
      ),

      // ─── Standalone Routes ───────────────────────────
      GoRoute(
        name: AppRoutes.qrScanner,
        path: '/qr-scanner',
        builder: (context, state) => const QrScannerPage(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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

import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/features/auth/domain/entities/user.dart';
import 'package:smart_campus_operations_system/features/auth/presentation/providers/auth_provider.dart';

/// Route guard logic for authentication and role-based access.
class RouteGuards {
  RouteGuards._();

  static const _unauthenticatedPaths = ['/login', '/register'];

  /// Global redirect function for GoRouter.
  static String? globalRedirect(AuthState authState, GoRouterState routerState) {
    final isAuthenticated = authState.isAuthenticated;
    final currentPath = routerState.uri.path;
    final isOnAuthPage = _unauthenticatedPaths.contains(currentPath);

    // Not authenticated + trying to access protected route → login
    if (!isAuthenticated && !isOnAuthPage) {
      return '/login';
    }

    // Authenticated + on auth page → role-based home
    if (isAuthenticated && isOnAuthPage) {
      return authState.user?.role == UserRole.staff ? '/staff/dashboard' : '/timetable';
    }

    // Staff trying to access student-only shell routes → redirect to staff home
    if (isAuthenticated && authState.user?.role == UserRole.staff) {
      if (currentPath == '/timetable' || currentPath == '/events') {
        return '/staff/dashboard';
      }
    }

    return null;
  }
}

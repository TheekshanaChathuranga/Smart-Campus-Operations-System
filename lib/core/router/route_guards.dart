import 'package:go_router/go_router.dart';
import 'package:smart_campus_operations_system/features/auth/presentation/providers/auth_provider.dart';

/// Route guard logic for authentication and role-based access.
class RouteGuards {
  RouteGuards._();

  /// Auth-aware unauthenticated routes.
  static const _unauthenticatedPaths = ['/login', '/register'];

  /// Global redirect function for GoRouter.
  static String? globalRedirect(AuthState authState, GoRouterState routerState) {
    final isAuthenticated = authState.isAuthenticated;
    final currentPath = routerState.uri.path;
    final isOnAuthPage = _unauthenticatedPaths.contains(currentPath);

    // If not authenticated and trying to access protected route → login
    if (!isAuthenticated && !isOnAuthPage) {
      return '/login';
    }

    // If authenticated and on auth page → redirect to home
    if (isAuthenticated && isOnAuthPage) {
      return '/timetable';
    }

    // No redirect needed
    return null;
  }
}

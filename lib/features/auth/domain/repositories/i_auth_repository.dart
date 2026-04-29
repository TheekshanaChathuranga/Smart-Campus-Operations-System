import 'package:smart_campus_operations_system/features/auth/domain/entities/user.dart';

/// Abstract interface for authentication operations.
abstract class IAuthRepository {
  /// Log in with email and password. Returns the authenticated [User].
  Future<User> login(String email, String password);

  /// Register a new user. Returns the created [User].
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });

  /// Log out the current user.
  Future<void> logout();

  /// Get the currently cached/logged-in user, or null.
  Future<User?> getCurrentUser();

  /// Check if a user is currently authenticated.
  Future<bool> isAuthenticated();
}

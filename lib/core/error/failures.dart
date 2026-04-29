/// Base failure class for domain-level error handling.
sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Network-related failure (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred.']);
}

/// Server-side failure (5xx, unexpected responses)
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure([super.message = 'Server error occurred.', this.statusCode]);
}

/// Database operation failure
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error occurred.']);
}

/// Authentication failure (invalid credentials, expired token)
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// Validation failure (form input errors)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error.']);
}

/// Cache failure (SharedPreferences issues)
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred.']);
}

/// Location service failure
class LocationFailure extends Failure {
  const LocationFailure([super.message = 'Location service error.']);
}

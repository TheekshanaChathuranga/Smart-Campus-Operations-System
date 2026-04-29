/// Base exception for data-layer errors.
class AppException implements Exception {
  final String message;
  const AppException([this.message = 'An unexpected error occurred.']);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a network request fails.
class NetworkException extends AppException {
  final int? statusCode;
  const NetworkException([super.message = 'Network request failed.', this.statusCode]);
}

/// Thrown when the server returns an error response.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException([super.message = 'Server error.', this.statusCode]);
}

/// Thrown when a database operation fails.
class DatabaseException extends AppException {
  const DatabaseException([super.message = 'Database operation failed.']);
}

/// Thrown when authentication fails.
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed.']);
}

/// Thrown when cache read/write fails.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache operation failed.']);
}

/// Thrown when location services fail.
class LocationException extends AppException {
  const LocationException([super.message = 'Location service failed.']);
}

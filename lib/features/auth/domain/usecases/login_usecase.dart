import 'package:smart_campus_operations_system/features/auth/domain/entities/user.dart';
import 'package:smart_campus_operations_system/features/auth/domain/repositories/i_auth_repository.dart';

/// Use case for user login.
class LoginUseCase {
  final IAuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<User> call(String email, String password) {
    return _repository.login(email, password);
  }
}

/// Use case for user registration.
class RegisterUseCase {
  final IAuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  }
}

/// Use case to get the current authenticated user.
class GetCurrentUserUseCase {
  final IAuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<User?> call() {
    return _repository.getCurrentUser();
  }
}

/// Use case for logout.
class LogoutUseCase {
  final IAuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() {
    return _repository.logout();
  }
}

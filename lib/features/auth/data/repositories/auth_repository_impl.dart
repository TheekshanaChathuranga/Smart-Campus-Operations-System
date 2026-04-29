import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/auth/data/datasources/auth_local_ds.dart';

import 'package:smart_campus_operations_system/features/auth/domain/entities/user.dart';
import 'package:smart_campus_operations_system/features/auth/domain/repositories/i_auth_repository.dart';

/// Concrete implementation of [IAuthRepository] using local data sources.
class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._localDataSource);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<User> login(String email, String password) async {
    final userModel = await _localDataSource.getUserByEmail(email);
    if (userModel == null) {
      throw const AuthException('No account found with this email.');
    }

    final hashedPassword = _hashPassword(password);
    if (userModel.passwordHash != hashedPassword) {
      throw const AuthException('Invalid password.');
    }

    await _localDataSource.cacheUserId(userModel.id);
    return userModel.toEntity();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final hashedPassword = _hashPassword(password);

    final userId = await _localDataSource.insertUser({
      'name': name,
      'email': email,
      'password_hash': hashedPassword,
      'role': role.name,
    });

    final user = User(
      id: userId,
      name: name,
      email: email,
      role: role,
      createdAt: DateTime.now(),
    );

    await _localDataSource.cacheUserId(userId);
    return user;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userId = await _localDataSource.getCachedUserId();
    if (userId == null) return null;

    final userModel = await _localDataSource.getUserById(userId);
    return userModel?.toEntity();
  }

  @override
  Future<bool> isAuthenticated() async {
    return _localDataSource.isLoggedIn;
  }
}

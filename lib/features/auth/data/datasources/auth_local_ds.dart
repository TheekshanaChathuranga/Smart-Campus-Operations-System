import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/database/schema.dart';
import 'package:smart_campus_operations_system/core/error/exceptions.dart';
import 'package:smart_campus_operations_system/features/auth/data/models/user_model.dart';

/// Local data source for auth: SharedPreferences for session, SQLite for user records.
class AuthLocalDataSource {
  final DatabaseHelper _dbHelper;
  final SharedPreferences _prefs;

  static const String _userIdKey = 'current_user_id';
  static const String _tokenKey = 'auth_token';

  AuthLocalDataSource(this._dbHelper, this._prefs);

  // ─── Session Management (SharedPreferences) ────────
  Future<void> cacheUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
    // Simulate a token for demo purposes
    await _prefs.setString(_tokenKey, 'mock_token_$userId');
  }

  Future<int?> getCachedUserId() async {
    return _prefs.getInt(_userIdKey);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_tokenKey);
  }

  bool get isLoggedIn => _prefs.containsKey(_userIdKey);

  // ─── User CRUD (SQLite) ────────────────────────────
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.usersTable,
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return UserModel.fromMap(results.first);
    } catch (e) {
      throw DatabaseException('Failed to query user: $e');
    }
  }

  Future<UserModel?> getUserById(int id) async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        Schema.usersTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (results.isEmpty) return null;
      return UserModel.fromMap(results.first);
    } catch (e) {
      throw DatabaseException('Failed to query user: $e');
    }
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert(
        Schema.usersTable,
        userData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw const AuthException('An account with this email already exists.');
      }
      throw DatabaseException('Failed to insert user: $e');
    }
  }
}

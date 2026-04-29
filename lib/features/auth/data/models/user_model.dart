import 'package:smart_campus_operations_system/features/auth/domain/entities/user.dart';

/// Data model for [User] with JSON/Map serialization.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String passwordHash;
  final String role;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
    required this.createdAt,
  });

  // ─── From/To Map (SQLite) ────────────────────────────
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      role: map['role'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'role': role,
      'created_at': createdAt,
    };
  }

  /// Map without ID (for inserts where ID is auto-generated).
  Map<String, dynamic> toInsertMap() {
    return {
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'role': role,
    };
  }

  // ─── From/To JSON (API) ─────────────────────────────
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: json['password_hash'] as String? ?? '',
      role: json['role'] as String,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'created_at': createdAt,
    };
  }

  // ─── Domain Conversion ──────────────────────────────
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      role: UserRole.fromString(role),
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      passwordHash: '',
      role: user.role.name,
      createdAt: user.createdAt.toIso8601String(),
    );
  }
}

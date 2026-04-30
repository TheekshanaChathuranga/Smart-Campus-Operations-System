import 'package:smart_campus_operations_system/features/events/domain/entities/registration.dart';

/// Data model for registrations with Map serialization.
class RegistrationModel {
  final int id;
  final int userId;
  final int eventId;
  final String qrCode;
  final String registeredAt;
  final String status;

  const RegistrationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.qrCode,
    required this.registeredAt,
    this.status = 'registered',
  });

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      eventId: map['event_id'] as int,
      qrCode: map['qr_code'] as String,
      registeredAt: map['registered_at'] as String,
      status: map['status'] as String? ?? 'registered',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'event_id': eventId,
      'qr_code': qrCode,
    };
  }

  Registration toEntity() {
    return Registration(
      id: id,
      userId: userId,
      eventId: eventId,
      qrCode: qrCode,
      registeredAt: DateTime.tryParse(registeredAt) ?? DateTime.now(),
      status: status,
    );
  }
}

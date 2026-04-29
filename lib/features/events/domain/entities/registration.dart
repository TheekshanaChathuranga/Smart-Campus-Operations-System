/// Domain entity representing an event registration.
class Registration {
  final int id;
  final int userId;
  final int eventId;
  final String qrCode;
  final DateTime registeredAt;
  final String status; // 'registered' | 'attended'

  const Registration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.qrCode,
    required this.registeredAt,
    this.status = 'registered',
  });

  bool get isAttended => status == 'attended';
}


/// Result of a successful QR code check-in validation.
class CheckInResult {
  final String studentName;
  final String eventTitle;
  final String qrCode;
  final DateTime registeredAt;

  const CheckInResult({
    required this.studentName,
    required this.eventTitle,
    required this.qrCode,
    required this.registeredAt,
  });
}

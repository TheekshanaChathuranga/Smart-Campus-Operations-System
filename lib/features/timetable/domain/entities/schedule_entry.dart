/// Domain entity representing a single schedule entry/class.
class ScheduleEntry {
  final int id;
  final String subject;
  final String instructor;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final int color;

  const ScheduleEntry({
    required this.id,
    required this.subject,
    required this.instructor,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.color,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleEntry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

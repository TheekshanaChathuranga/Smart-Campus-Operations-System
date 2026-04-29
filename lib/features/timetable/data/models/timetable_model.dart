import 'package:smart_campus_operations_system/features/timetable/domain/entities/schedule_entry.dart';

/// Data model for timetable entries with Map serialization.
class TimetableModel {
  final int id;
  final String subject;
  final String instructor;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final int color;

  const TimetableModel({
    required this.id,
    required this.subject,
    required this.instructor,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.color,
  });

  factory TimetableModel.fromMap(Map<String, dynamic> map) {
    return TimetableModel(
      id: map['id'] as int,
      subject: map['subject'] as String,
      instructor: map['instructor'] as String,
      day: map['day'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      room: map['room'] as String,
      color: map['color'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'instructor': instructor,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'color': color,
    };
  }

  ScheduleEntry toEntity() {
    return ScheduleEntry(
      id: id,
      subject: subject,
      instructor: instructor,
      day: day,
      startTime: startTime,
      endTime: endTime,
      room: room,
      color: color,
    );
  }
}

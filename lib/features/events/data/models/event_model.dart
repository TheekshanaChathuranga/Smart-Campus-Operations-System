import 'package:smart_campus_operations_system/features/events/domain/entities/event.dart';

/// Data model for events with Map serialization.
class EventModel {
  final int id;
  final String title;
  final String description;
  final String date;
  final String location;
  final int capacity;
  final int registeredCount;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.capacity,
    this.registeredCount = 0,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      date: map['date'] as String,
      location: map['location'] as String,
      capacity: map['capacity'] as int,
      registeredCount: map['registered_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'capacity': capacity,
    };
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: DateTime.tryParse(date) ?? DateTime.now(),
      location: location,
      capacity: capacity,
      registeredCount: registeredCount,
    );
  }
}

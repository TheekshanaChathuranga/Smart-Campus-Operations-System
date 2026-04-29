/// Domain entity representing a campus event.
class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int capacity;
  final int registeredCount;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.capacity,
    this.registeredCount = 0,
  });

  int get spotsLeft => capacity - registeredCount;
  bool get isFull => spotsLeft <= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

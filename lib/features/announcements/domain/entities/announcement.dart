/// Domain entity representing an announcement.
class Announcement {
  final int id;
  final String title;
  final String body;
  final String category;
  final DateTime publishedAt;
  final bool isNew;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.publishedAt,
    this.isNew = false,
  });
}

import 'package:smart_campus_operations_system/features/announcements/domain/entities/announcement.dart';

/// Data model for announcements.
class AnnouncementModel {
  final int id;
  final String title;
  final String body;
  final String category;
  final String publishedAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.publishedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String? ?? 'General',
      publishedAt: json['published_at'] as String,
    );
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) =>
      AnnouncementModel.fromJson(map);


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'published_at': publishedAt,
    };
  }

  Announcement toEntity() {
    final date = DateTime.tryParse(publishedAt) ?? DateTime.now();
    return Announcement(
      id: id,
      title: title,
      body: body,
      category: category,
      publishedAt: date,
      isNew: DateTime.now().difference(date).inHours < 24,
    );
  }
}

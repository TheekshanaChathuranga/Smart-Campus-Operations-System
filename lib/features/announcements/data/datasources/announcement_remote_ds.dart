import 'package:dio/dio.dart';
import 'package:smart_campus_operations_system/features/announcements/data/models/announcement_model.dart';

/// Remote data source for announcements using Dio REST API.
/// Falls back to mock data when the API is unavailable.
class AnnouncementRemoteDataSource {
  final Dio _dio;

  AnnouncementRemoteDataSource(this._dio);

  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      // Attempt to fetch from API
      final response = await _dio.get('/announcements');
      final List data = response.data as List;
      return data.map((json) => AnnouncementModel.fromJson(json)).toList();
    } catch (_) {
      // Return mock data for standalone operation
      return _getMockAnnouncements();
    }
  }

  /// Mock announcements for demo purposes.
  List<AnnouncementModel> _getMockAnnouncements() {
    return [
      AnnouncementModel(
        id: 1,
        title: 'Campus WiFi Upgrade This Weekend',
        body: 'The IT department will be upgrading the campus WiFi infrastructure this Saturday and Sunday. Expect intermittent connectivity between 10 PM Friday and 6 AM Monday. We recommend downloading any essential materials before the upgrade window. The new infrastructure will provide 3x faster speeds and better coverage in all buildings.',
        category: 'IT Services',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      AnnouncementModel(
        id: 2,
        title: 'Mid-Semester Exam Schedule Released',
        body: 'The mid-semester examination schedule for all departments has been published. Please check the academic portal for your personalized timetable. Contact the examination cell for any conflicts or concerns. The exams will commence from next Monday and run for two weeks.',
        category: 'Academic',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      ),
      AnnouncementModel(
        id: 3,
        title: 'New Library Hours — Extended Study Sessions',
        body: 'Starting next week, the Central Library will extend its hours until midnight (12:00 AM) on weekdays to support students during the examination period. The digital reading room will remain accessible 24/7 with valid student ID. Refreshments are available at the library café.',
        category: 'Library',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
      AnnouncementModel(
        id: 4,
        title: 'Scholarship Applications Open',
        body: 'Applications for the Merit-Based Scholarship Program 2026-27 are now open. Eligible students with a GPA of 3.5 or above can apply through the student portal. The scholarship covers tuition fees, hostel accommodation, and provides a monthly stipend. Deadline: June 30, 2026.',
        category: 'Financial Aid',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      ),
      AnnouncementModel(
        id: 5,
        title: 'Campus Sustainability Drive',
        body: 'Join us in making our campus greener! The Environmental Club is organizing a tree plantation drive this Friday. Volunteers will receive eco-friendly merchandise and community service hours. Assembly point: Main Gate at 7:00 AM. Bring your own water bottles!',
        category: 'Campus Life',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      ),
      AnnouncementModel(
        id: 6,
        title: 'Guest Lecture: AI in Healthcare',
        body: 'Dr. Priya Mehta, Chief AI Officer at HealthTech Solutions, will deliver a guest lecture on "Transforming Healthcare with Artificial Intelligence" on Thursday at 3:00 PM in the CS Auditorium. All students and faculty are welcome. Certificates of attendance will be provided.',
        category: 'Academic',
        publishedAt: DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      ),
    ];
  }
}

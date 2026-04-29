import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:smart_campus_operations_system/core/database/database_helper.dart';
import 'package:smart_campus_operations_system/core/network/dio_client.dart';

// Auth
import 'package:smart_campus_operations_system/features/auth/data/datasources/auth_local_ds.dart';
import 'package:smart_campus_operations_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_campus_operations_system/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:smart_campus_operations_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_campus_operations_system/features/auth/presentation/providers/auth_provider.dart';

// Timetable
import 'package:smart_campus_operations_system/features/timetable/data/datasources/timetable_local_ds.dart';
import 'package:smart_campus_operations_system/features/timetable/data/repositories/timetable_repository_impl.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/repositories/i_timetable_repository.dart';
import 'package:smart_campus_operations_system/features/timetable/domain/usecases/get_schedule_usecase.dart';
import 'package:smart_campus_operations_system/features/timetable/presentation/providers/timetable_notifier.dart';

// Events
import 'package:smart_campus_operations_system/features/events/data/datasources/event_local_ds.dart';
import 'package:smart_campus_operations_system/features/events/data/repositories/event_repository_impl.dart';
import 'package:smart_campus_operations_system/features/events/domain/repositories/i_event_repository.dart';
import 'package:smart_campus_operations_system/features/events/domain/usecases/register_event_usecase.dart';
import 'package:smart_campus_operations_system/features/events/presentation/providers/event_notifier.dart';

// Announcements
import 'package:smart_campus_operations_system/features/announcements/data/datasources/announcement_remote_ds.dart';
import 'package:smart_campus_operations_system/features/announcements/data/repositories/announcement_repository_impl.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/repositories/i_announcement_repository.dart';
import 'package:smart_campus_operations_system/features/announcements/domain/usecases/get_announcements_usecase.dart';
import 'package:smart_campus_operations_system/features/announcements/presentation/providers/announcement_notifier.dart';

// Campus Map
import 'package:smart_campus_operations_system/features/campus_map/data/datasources/location_service.dart';
import 'package:smart_campus_operations_system/features/campus_map/data/repositories/map_repository_impl.dart';
import 'package:smart_campus_operations_system/features/campus_map/domain/usecases/get_current_location_usecase.dart';
import 'package:smart_campus_operations_system/features/campus_map/presentation/providers/map_notifier.dart';

// ─── Core Providers ────────────────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return DioClient.create(prefs);
});

// ─── Auth Providers ────────────────────────────────────────
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(
    ref.read(databaseHelperProvider),
    ref.read(sharedPreferencesProvider),
  );
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authLocalDataSourceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

// ─── Timetable Providers ───────────────────────────────────
final timetableLocalDsProvider = Provider<TimetableLocalDataSource>((ref) {
  return TimetableLocalDataSource(ref.read(databaseHelperProvider));
});

final timetableRepositoryProvider = Provider<ITimetableRepository>((ref) {
  return TimetableRepositoryImpl(ref.read(timetableLocalDsProvider));
});

final getScheduleUseCaseProvider = Provider<GetScheduleUseCase>((ref) {
  return GetScheduleUseCase(ref.read(timetableRepositoryProvider));
});

final timetableNotifierProvider = StateNotifierProvider<TimetableNotifier, TimetableState>((ref) {
  return TimetableNotifier(ref.read(getScheduleUseCaseProvider));
});

// ─── Events Providers ──────────────────────────────────────
final eventLocalDsProvider = Provider<EventLocalDataSource>((ref) {
  return EventLocalDataSource(ref.read(databaseHelperProvider));
});

final eventRepositoryProvider = Provider<IEventRepository>((ref) {
  return EventRepositoryImpl(ref.read(eventLocalDsProvider));
});

final registerEventUseCaseProvider = Provider<RegisterEventUseCase>((ref) {
  return RegisterEventUseCase(ref.read(eventRepositoryProvider));
});

final eventNotifierProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(ref.read(eventRepositoryProvider));
});

// ─── Announcements Providers ───────────────────────────────
final announcementRemoteDsProvider = Provider<AnnouncementRemoteDataSource>((ref) {
  return AnnouncementRemoteDataSource(ref.read(dioProvider));
});

final announcementRepositoryProvider = Provider<IAnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(ref.read(announcementRemoteDsProvider));
});

final getAnnouncementsUseCaseProvider = Provider<GetAnnouncementsUseCase>((ref) {
  return GetAnnouncementsUseCase(ref.read(announcementRepositoryProvider));
});

final announcementNotifierProvider = StateNotifierProvider<AnnouncementNotifier, AnnouncementState>((ref) {
  return AnnouncementNotifier(ref.read(getAnnouncementsUseCaseProvider));
});

// ─── Campus Map Providers ──────────────────────────────────
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final mapRepositoryProvider = Provider<MapRepositoryImpl>((ref) {
  return MapRepositoryImpl(ref.read(locationServiceProvider));
});

final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.read(mapRepositoryProvider));
});

final mapNotifierProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier(ref.read(getCurrentLocationUseCaseProvider));
});

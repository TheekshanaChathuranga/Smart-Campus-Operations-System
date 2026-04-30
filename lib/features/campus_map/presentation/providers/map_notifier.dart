import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_campus_operations_system/features/campus_map/domain/usecases/get_current_location_usecase.dart';

/// Campus landmark model.
class CampusLandmark {
  final String name;
  final String description;
  final LatLng position;
  final String category;

  const CampusLandmark({
    required this.name,
    required this.description,
    required this.position,
    required this.category,
  });
}

/// State for campus map.
class MapState {
  final LatLng? userLocation;
  final List<CampusLandmark> landmarks;
  final bool isLoading;
  final String? error;
  final CampusLandmark? selectedLandmark;

  const MapState({
    this.userLocation,
    this.landmarks = const [],
    this.isLoading = false,
    this.error,
    this.selectedLandmark,
  });

  MapState copyWith({
    LatLng? userLocation,
    List<CampusLandmark>? landmarks,
    bool? isLoading,
    String? error,
    CampusLandmark? selectedLandmark,
    bool clearError = false,
    bool clearLandmark = false,
  }) {
    return MapState(
      userLocation: userLocation ?? this.userLocation,
      landmarks: landmarks ?? this.landmarks,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedLandmark: clearLandmark ? null : (selectedLandmark ?? this.selectedLandmark),
    );
  }
}

/// StateNotifier for campus map.
class MapNotifier extends StateNotifier<MapState> {
  final GetCurrentLocationUseCase _getLocationUseCase;

  MapNotifier(this._getLocationUseCase) : super(const MapState()) {
    _loadLandmarks();
  }

  /// Load sample campus landmarks.
  void _loadLandmarks() {
    const campusCenter = LatLng(6.0636, 80.5408);

    state = state.copyWith(
      landmarks: [
        const CampusLandmark(
          name: 'Auditorium',
          description: 'Main auditorium for university events, conferences, and performances.',
          position: LatLng(6.0648049247308595, 80.54089856047055),
          category: 'venue',
        ),
        const CampusLandmark(
          name: 'Dean Office',
          description: 'Administrative office for the Dean and university officials.',
          position: LatLng(6.063465990313679, 80.5420948256443),
          category: 'admin',
        ),
        const CampusLandmark(
          name: 'Old Canteen',
          description: 'Traditional cafeteria serving local meals and snacks.',
          position: LatLng(6.063289954864187, 80.54154765502672),
          category: 'food',
        ),
        const CampusLandmark(
          name: 'New Canteen',
          description: 'Modern cafeteria with a variety of fast food and beverages.',
          position: LatLng(6.063060575252885, 80.54168712989001),
          category: 'food',
        ),
        const CampusLandmark(
          name: 'Library',
          description: 'Central library with extensive collections and reading spaces.',
          position: LatLng(6.062932549380921, 80.54072689910033),
          category: 'library',
        ),
        const CampusLandmark(
          name: 'Girls Hostel',
          description: 'Accommodation facility for female students.',
          position: LatLng(6.06333796453792, 80.53973984622156),
          category: 'hostel',
        ),
        const CampusLandmark(
          name: 'Boys Hostel',
          description: 'Accommodation facility for male students.',
          position: LatLng(6.0640821139285, 80.53957623139763),
          category: 'hostel',
        ),
        const CampusLandmark(
          name: 'Maintenance Room',
          description: 'Facility management and maintenance operations center.',
          position: LatLng(6.063866070657854, 80.53976398602416),
          category: 'maintenance',
        ),
        const CampusLandmark(
          name: 'Union Office',
          description: 'Headquarters for the Student Union and various clubs.',
          position: LatLng(6.063331963303256, 80.54029707504574),
          category: 'union',
        ),
      ],
      userLocation: campusCenter,
    );
  }

  /// Get the current device location.
  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final position = await _getLocationUseCase();
      state = state.copyWith(
        userLocation: LatLng(position.latitude, position.longitude),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Select a landmark.
  void selectLandmark(CampusLandmark? landmark) {
    state = state.copyWith(
      selectedLandmark: landmark,
      clearLandmark: landmark == null,
    );
  }
}

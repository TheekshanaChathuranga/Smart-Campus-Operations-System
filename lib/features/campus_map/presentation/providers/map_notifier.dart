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
    // Default campus center (example coordinates)
    const campusCenter = LatLng(12.9716, 77.5946); // Bangalore coordinates as sample

    state = state.copyWith(
      landmarks: [
        CampusLandmark(
          name: 'Main Auditorium',
          description: 'Central auditorium for events and lectures. Capacity: 500',
          position: LatLng(campusCenter.latitude + 0.001, campusCenter.longitude + 0.001),
          category: 'Building',
        ),
        CampusLandmark(
          name: 'Central Library',
          description: 'Open 8 AM - 12 AM. 3 floors, digital reading room available.',
          position: LatLng(campusCenter.latitude - 0.001, campusCenter.longitude + 0.002),
          category: 'Library',
        ),
        CampusLandmark(
          name: 'CS Block',
          description: 'Computer Science Department. Rooms CS-101 to CS-405.',
          position: LatLng(campusCenter.latitude + 0.002, campusCenter.longitude - 0.001),
          category: 'Department',
        ),
        CampusLandmark(
          name: 'Sports Complex',
          description: 'Indoor and outdoor facilities. Cricket, Football, Basketball.',
          position: LatLng(campusCenter.latitude - 0.002, campusCenter.longitude - 0.002),
          category: 'Sports',
        ),
        CampusLandmark(
          name: 'Innovation Center',
          description: 'Startup incubation hub and maker space. 3 floors.',
          position: LatLng(campusCenter.latitude + 0.003, campusCenter.longitude + 0.002),
          category: 'Building',
        ),
        CampusLandmark(
          name: 'Cafeteria',
          description: 'Main dining hall. Breakfast, lunch, dinner and snacks.',
          position: LatLng(campusCenter.latitude, campusCenter.longitude - 0.001),
          category: 'Food',
        ),
        CampusLandmark(
          name: 'Student Hostel Block A',
          description: 'Residential block for 1st and 2nd year students.',
          position: LatLng(campusCenter.latitude - 0.003, campusCenter.longitude + 0.001),
          category: 'Hostel',
        ),
        CampusLandmark(
          name: 'Open Air Theatre',
          description: 'Outdoor venue for cultural events. Capacity: 300',
          position: LatLng(campusCenter.latitude + 0.001, campusCenter.longitude - 0.003),
          category: 'Venue',
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

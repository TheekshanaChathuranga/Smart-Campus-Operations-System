import 'package:geolocator/geolocator.dart';
import 'package:smart_campus_operations_system/features/campus_map/data/datasources/location_service.dart';

/// Repository implementation for campus map operations.
class MapRepositoryImpl {
  final LocationService _locationService;

  MapRepositoryImpl(this._locationService);

  Future<Position> getCurrentLocation() {
    return _locationService.getCurrentPosition();
  }

  Stream<Position> getLocationStream() {
    return _locationService.getPositionStream();
  }
}

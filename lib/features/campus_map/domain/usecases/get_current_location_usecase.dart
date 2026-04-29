import 'package:geolocator/geolocator.dart';
import 'package:smart_campus_operations_system/features/campus_map/data/repositories/map_repository_impl.dart';

/// Use case to get the current device location.
class GetCurrentLocationUseCase {
  final MapRepositoryImpl _repository;

  const GetCurrentLocationUseCase(this._repository);

  Future<Position> call() {
    return _repository.getCurrentLocation();
  }
}

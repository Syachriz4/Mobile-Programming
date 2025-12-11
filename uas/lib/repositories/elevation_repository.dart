import '../models/elevation_model.dart';
import 'elevation_service.dart';

class ElevationRepository {
  final ElevationService _elevationService = ElevationService();

  Future<double> getElevationByCoordinate(double latitude, double longitude) async {
    return await _elevationService.getElevationByCoordinate(latitude, longitude);
  }

  Future<List<ElevationData>> getElevationByCoordinates(
    List<Map<String, double>> coordinates,
  ) async {
    return await _elevationService.getElevationByCoordinates(coordinates);
  }

  String formatElevation(double elevation) {
    return '${elevation.toStringAsFixed(0)} m';
  }

  String getDifficultyLevel(double elevation) {
    if (elevation < 500) return 'Easy';
    if (elevation < 1000) return 'Moderate';
    if (elevation < 2000) return 'Challenging';
    return 'Extreme';
  }
}

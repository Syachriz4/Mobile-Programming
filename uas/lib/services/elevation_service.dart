import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/elevation_model.dart';

class ElevationService {
  static const String _baseUrl = 'https://api.open-elevation.com/api/v1/lookup';

  Future<double> getElevationByCoordinate(double latitude, double longitude) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl?locations=$latitude,$longitude');
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ElevationException('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List?;
        
        if (results != null && results.isNotEmpty) {
          return (results[0]['elevation'] as num).toDouble();
        }
        throw ElevationException('No elevation data found');
      } else {
        throw ElevationException('Failed to fetch elevation: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ElevationException) rethrow;
      throw ElevationException('Error: $e');
    }
  }

  Future<List<ElevationData>> getElevationByCoordinates(
    List<Map<String, double>> coordinates,
  ) async {
    try {
      final String locations = coordinates
          .map((coord) => '${coord['lat']},${coord['lon']}')
          .join('|');
      
      final Uri uri = Uri.parse('$_baseUrl?locations=$locations');
      
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ElevationException('Request timeout'),
      );

      if (response.statusCode == 200) {
        final elevationResponse = ElevationResponse.fromJson(
          jsonDecode(response.body),
        );
        return elevationResponse.results;
      } else {
        throw ElevationException('Failed to fetch elevation: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ElevationException) rethrow;
      throw ElevationException('Error: $e');
    }
  }
}

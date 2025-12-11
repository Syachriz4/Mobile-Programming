import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);

  @override
  String toString() => 'WeatherException: $message';
}

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> getWeatherByCoordinate(double latitude, double longitude) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,humidity,weather_code,wind_speed_10m',
      );

      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw WeatherException('Request timeout after 10 seconds'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherData.fromJson(json['current']);
      } else {
        throw WeatherException('Failed to fetch weather: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Error: $e');
    }
  }

  String getWeatherCondition(int weatherCode) {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode == 1 || weatherCode == 2) return 'Mainly clear';
    if (weatherCode == 3) return 'Overcast';
    if (weatherCode == 45 || weatherCode == 48) return 'Foggy';
    if ((weatherCode >= 51 && weatherCode <= 55) ||
        (weatherCode >= 80 && weatherCode <= 82)) return 'Rainy';
    if ((weatherCode >= 61 && weatherCode <= 67) ||
        (weatherCode >= 85 && weatherCode <= 86)) return 'Heavy rain';
    if ((weatherCode >= 71 && weatherCode <= 77)) return 'Snowy';
    if ((weatherCode >= 95 && weatherCode <= 99)) return 'Thunderstorm';
    return 'Unknown';
  }

  String getWeatherEmoji(int weatherCode) {
    if (weatherCode == 0) return '☀️';
    if (weatherCode == 1 || weatherCode == 2) return '🌤️';
    if (weatherCode == 3) return '☁️';
    if (weatherCode == 45 || weatherCode == 48) return '🌫️';
    if ((weatherCode >= 51 && weatherCode <= 55) ||
        (weatherCode >= 80 && weatherCode <= 82)) return '🌧️';
    if ((weatherCode >= 61 && weatherCode <= 67) ||
        (weatherCode >= 85 && weatherCode <= 86)) return '🌧️';
    if ((weatherCode >= 71 && weatherCode <= 77)) return '❄️';
    if ((weatherCode >= 95 && weatherCode <= 99)) return '⛈️';
    return '🌍';
  }
}

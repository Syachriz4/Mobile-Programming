import '../models/weather_model.dart';
import 'weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService = WeatherService();

  Future<WeatherData> getWeatherByCoordinate(double latitude, double longitude) async {
    return await _weatherService.getWeatherByCoordinate(latitude, longitude);
  }

  String getWeatherEmoji(int weatherCode) {
    if (weatherCode == 0) return '☀️';
    if (weatherCode == 1 || weatherCode == 2) return '⛅';
    if (weatherCode == 3) return '☁️';
    if (weatherCode >= 45 && weatherCode <= 48) return '🌫️';
    if (weatherCode >= 51 && weatherCode <= 67) return '🌧️';
    if (weatherCode >= 80 && weatherCode <= 82) return '🌧️';
    if (weatherCode >= 85 && weatherCode <= 86) return '🌨️';
    if (weatherCode >= 71 && weatherCode <= 77) return '❄️';
    if (weatherCode >= 80 && weatherCode <= 99) return '⛈️';
    return '🌤️';
  }

  String getWeatherCondition(int code) {
    if (code == 0) return 'Clear';
    if (code == 1 || code == 2) return 'Partly cloudy';
    if (code == 3) return 'Overcast';
    if (code >= 45 && code <= 48) return 'Foggy';
    if (code >= 51 && code <= 67) return 'Drizzle';
    if (code >= 80 && code <= 82) return 'Rain';
    if (code >= 85 && code <= 86) return 'Snow showers';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }
}

class WeatherData {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      weatherCode: json['weather_code'],
    );
  }

  Map<String, dynamic> toJson() => {
    'temperature_2m': temperature,
    'relative_humidity_2m': humidity,
    'wind_speed_10m': windSpeed,
    'weather_code': weatherCode,
  };
}

class WeatherResponse {
  final WeatherData current;

  WeatherResponse({required this.current});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: WeatherData.fromJson(json['current']),
    );
  }
}

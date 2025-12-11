# API Integration Reference

## Weather API - Open-Meteo

### Endpoint
```
GET https://api.open-meteo.com/v1/forecast
```

### Request Parameters
```
latitude=<user_latitude>
longitude=<user_longitude>
current=temperature_2m,humidity,weather_code,wind_speed_10m
```

### Example Request
```
https://api.open-meteo.com/v1/forecast?latitude=-7.9797&longitude=112.7505&current=temperature_2m,humidity,weather_code,wind_speed_10m
```

### Response Structure
```json
{
  "latitude": -7.98,
  "longitude": 112.75,
  "generationtime_ms": 0.123,
  "utc_offset_seconds": 0,
  "current": {
    "time": "2025-12-11T10:30:00",
    "interval": 900,
    "temperature_2m": 28.5,
    "humidity": 65,
    "weather_code": 3,
    "wind_speed_10m": 12.3
  }
}
```

### Weather Code Mapping
| Code | Condition | Emoji |
|------|-----------|-------|
| 0 | Clear sky | ☀️ |
| 1 | Mainly clear | 🌤️ |
| 2 | Partly cloudy | ⛅ |
| 3 | Overcast | ☁️ |
| 45 | Foggy | 🌫️ |
| 48 | Depositing rime fog | 🌫️ |
| 51-55 | Drizzle | 🌧️ |
| 61-65 | Rain | 🌧️ |
| 71-77 | Snow | ❄️ |
| 80-82 | Rain showers | 🌧️ |
| 85-86 | Snow showers | ❄️ |
| 95-99 | Thunderstorm | ⛈️ |

### Dart Implementation
```dart
// lib/services/weather_service.dart
Future<WeatherData> getWeatherByCoordinate(double lat, double lng) async {
  final uri = Uri.parse(
    'https://api.open-meteo.com/v1/forecast'
    '?latitude=$lat&longitude=$lng'
    '&current=temperature_2m,humidity,weather_code,wind_speed_10m'
  );
  
  final response = await http.get(uri)
    .timeout(const Duration(seconds: 10));
  
  if (response.statusCode == 200) {
    final data = WeatherResponse.fromJson(jsonDecode(response.body));
    return data.current;
  } else {
    throw WeatherException('Failed to fetch weather');
  }
}
```

### Used In
- `lib/pages/running_page.dart` - Weather widget display
- `lib/pages/hiking_page.dart` - Weather widget display
- `lib/repositories/weather_repository.dart` - Business logic

---

## Elevation API - Open-Elevation

### Endpoint
```
POST https://api.open-elevation.com/api/v1/lookup
```

### Request Body
```json
{
  "locations": [
    {"latitude": <lat>, "longitude": <lng>},
    {"latitude": <lat>, "longitude": <lng>}
  ]
}
```

### Example Request
```
POST https://api.open-elevation.com/api/v1/lookup
Content-Type: application/json

{
  "locations": [
    {"latitude": -7.9797, "longitude": 112.7505},
    {"latitude": -7.9800, "longitude": 112.7510}
  ]
}
```

### Response Structure
```json
{
  "results": [
    {
      "latitude": -7.9797,
      "longitude": 112.7505,
      "elevation": 568
    },
    {
      "latitude": -7.9800,
      "longitude": 112.7510,
      "elevation": 575
    }
  ]
}
```

### Difficulty Level Calculation
```dart
String getDifficultyLevel(double elevation) {
  if (elevation < 500) {
    return 'Easy';
  } else if (elevation < 1500) {
    return 'Moderate';
  } else {
    return 'Hard';
  }
}
```

### Dart Implementation
```dart
// lib/services/elevation_service.dart
Future<ElevationResponse> getElevationByCoordinates(
  List<Map<String, double>> locations
) async {
  final response = await http.post(
    Uri.parse('https://api.open-elevation.com/api/v1/lookup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'locations': locations}),
  ).timeout(const Duration(seconds: 10));
  
  if (response.statusCode == 200) {
    return ElevationResponse.fromJson(jsonDecode(response.body));
  } else {
    throw ElevationException('Failed to fetch elevation');
  }
}
```

### Used In
- `lib/pages/running_page.dart` - Elevation widget display
- `lib/pages/hiking_page.dart` - Elevation widget display
- `lib/repositories/elevation_repository.dart` - Business logic

---

## Google Maps API (Local Integration)

### Implementation
```dart
// lib/pages/running_page.dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(-7.9797, 112.7505),
    zoom: 15,
  ),
  myLocationEnabled: true,
  myLocationButtonEnabled: false,
  onCameraMove: _onCameraMove,
  onTap: _enableGPS,
)
```

### Used In
- `lib/pages/running_page.dart` - Map display with auto-pan
- `lib/pages/hiking_page.dart` - Map display with auto-pan

---

## GPS Tracking - Geolocator

### Implementation
```dart
// lib/pages/running_page.dart
LocationPermission permission = await Geolocator.requestPermission();
Position position = await Geolocator.getCurrentPosition();

Geolocator.getPositionStream().listen((Position position) {
  _updateMapToCurrentPosition(position);
});
```

### Used In
- `lib/pages/running_page.dart` - Real-time GPS tracking
- `lib/pages/hiking_page.dart` - Real-time GPS tracking

---

## Local Data Storage - SharedPreferences

### Keys Used
```dart
// Profile Data
'profileName' → String
'weeklyGoal' → double
'profileImagePath' → String

// Activities Data
'activities' → List<String> (JSON encoded)
```

### Implementation
```dart
// Save activity
final prefs = await SharedPreferences.getInstance();
List<Activity> activities = await _loadActivities();
activities.add(newActivity);
await prefs.setStringList(
  'activities',
  activities.map((a) => jsonEncode(a.toJson())).toList(),
);

// Load activities
final savedJson = prefs.getStringList('activities') ?? [];
final activities = savedJson
  .map((json) => Activity.fromJson(jsonDecode(json)))
  .toList();
```

### Used In
- `lib/main.dart` - App initialization
- `lib/pages/home_page.dart` - Profile loading
- `lib/pages/profile_page.dart` - Activity management, photo storage

---

## Image Picker - ImagePicker

### Implementation
```dart
// lib/pages/profile_page.dart
final ImagePicker _imagePicker = ImagePicker();

Future<void> _pickProfileImage() async {
  final XFile? image = await _imagePicker.pickImage(
    source: ImageSource.gallery,
  );
  
  if (image != null) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', image.path);
  }
}
```

### Used In
- `lib/pages/profile_page.dart` - Profile photo upload

---

## Error Handling Strategy

### API Errors
```dart
try {
  final data = await _weatherService.getWeatherByCoordinate(lat, lng);
} on WeatherException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Weather Error: ${e.message}')),
  );
}
```

### Network Timeout
```dart
final response = await http.get(uri).timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw TimeoutException('API timeout after 10s'),
);
```

### Permission Errors
```dart
LocationPermission permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}
```

---

## Testing APIs

### Test Weather API
```bash
curl "https://api.open-meteo.com/v1/forecast?latitude=-7.9797&longitude=112.7505&current=temperature_2m,humidity,weather_code,wind_speed_10m"
```

### Test Elevation API
```bash
curl -X POST "https://api.open-elevation.com/api/v1/lookup" \
  -H "Content-Type: application/json" \
  -d '{"locations":[{"latitude":-7.9797,"longitude":112.7505}]}'
```

---

## Performance Optimization

### Caching Strategy
- Weather data cached for 10 minutes
- Images cached by ImageCache
- API responses minimized with specific fields

### Timeout Handling
- 10-second timeout for all API calls
- Graceful error messages if timeout
- No blocking UI operations

### Batch Queries
- Elevation API supports multiple locations
- Reduces number of API calls
- More efficient for route tracking

---

## Dependencies

```yaml
http: ^1.1.0                       # HTTP client for APIs
google_maps_flutter: ^2.5.0        # Maps
geolocator: ^9.0.2                 # GPS tracking
shared_preferences: ^2.2.0         # Local storage
image_picker: ^0.8.9               # Photo upload
```

---

**Last Updated:** December 11, 2025  
**Version:** 1.0  
**Status:** ✅ Production Ready

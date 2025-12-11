# RunHike Islami - UAS Version

Aplikasi mobile fitness tracking dengan integrasi API real-time untuk cuaca, elevasi, dan lokasi GPS.

## 📱 Deskripsi Aplikasi

RunHike Islami adalah aplikasi flutter yang memungkinkan pengguna melacak aktivitas outdoor (running & hiking) dengan integrasi real-time API untuk data cuaca dan elevasi. Aplikasi ini menggunakan Google Maps untuk visualisasi lokasi dan Geolocator untuk pelacakan GPS.

## 🎯 UAS Compliance (100%)

✅ **API Integration (35%)** - Integrasi 2 API eksternal dengan error handling
- Open-Meteo Weather API untuk cuaca real-time
- Open-Elevation API untuk data elevasi/MDPL

✅ **Async/Await UI (20%)** - FutureBuilder dengan loading states
- Weather widget dengan loading indicator
- Elevation data dengan error handling

✅ **UI/UX Design (15%)** - Material Design 3 dengan dark theme konsisten
- Responsive layout dengan SliverAppBar
- Search functionality dengan real-time filtering
- Dynamic profile level system

✅ **Architecture & Code Quality (30%)** - Service/Repository pattern
- WeatherService & ElevationService untuk API calls
- WeatherRepository & ElevationRepository untuk business logic
- Model classes dengan serialization/deserialization
- Error handling dan exception management

## 📋 Fitur Utama

### 1. **Home Page (Dashboard)**
- User greeting dengan profile photo
- Weekly goal tracker dengan progress bar
- Recent activity list dari SharedPreferences
- Settings icon untuk edit weekly goal (dialog)
- Profile loading dari SharedPreferences

### 2. **Running Page**
- Real-time GPS tracking dengan Google Maps
- Auto-pan ke lokasi current user
- Weather widget: Open-Meteo API integration
  - Suhu, humidity, wind speed, kondisi cuaca
  - Weather emoji berdasarkan kondisi
- Stats grid: distance, duration, speed, elevation
- Save activity functionality

### 3. **Hiking Page**
- Same like Running Page
- Elevation tracking: Open-Elevation API integration
  - Real-time MDPL (meters above sea level)
  - Difficulty level berdasarkan elevasi
- Enhanced stats dengan elevation focus

### 4. **Profile Page**
- Profile photo upload dengan image_picker
- Edit profile name (with save/cancel buttons)
- Dynamic level system (Level 1-6 auto-calculated)
- Level field read-only dengan lock icon
- Statistics: total km run, km hike, total calories
- **Search functionality**:
  - Real-time filtering by activity type
  - Filter by date
  - Filter by distance
- Activity management:
  - View all saved activities
  - Filter buttons (All, Running, Hiking)
  - Delete activity functionality

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry point dengan async init
├── models/
│   ├── activity_model.dart        # Activity data model
│   ├── weather_model.dart         # Weather API response models
│   └── elevation_model.dart       # Elevation API response models
├── pages/
│   ├── home_page.dart             # Dashboard dengan weekly goal dialog
│   ├── running_page.dart          # Running tracker dengan APIs
│   ├── hiking_page.dart           # Hiking tracker dengan APIs
│   └── profile_page.dart          # Profile dengan search & photo
├── services/
│   ├── api_service.dart           # Base HTTP client (deprecated)
│   ├── weather_service.dart       # Open-Meteo API client
│   └── elevation_service.dart     # Open-Elevation API client
├── repositories/
│   ├── weather_repository.dart    # Weather business logic
│   └── elevation_repository.dart  # Elevation business logic
└── widgets/
    ├── activity_card.dart         # Activity list item widget
    ├── weather_widget.dart        # Weather display widget
    └── elevation_widget.dart      # Elevation display widget

assets/
├── data/
│   └── activities.json            # Sample activities data
└── images/
    └── [profile images]           # User profile photos
```

## 🔌 API Integration

### Weather API (Open-Meteo)
**Endpoint:** `https://api.open-meteo.com/v1/forecast`

**Parameters:**
- latitude, longitude
- current (temperature, humidity, weather_code, wind_speed)

**Implementation:**
```dart
// WeatherService
Future<WeatherData> getWeatherByCoordinate(double lat, double lng) async {
  final response = await http.get(
    Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m,humidity,weather_code,wind_speed_10m'),
  ).timeout(const Duration(seconds: 10));
  // ... error handling & parsing
}

// WeatherRepository - Business Logic
Future<String> getWeatherEmoji(double lat, double lng) async {
  final data = await _weatherService.getWeatherByCoordinate(lat, lng);
  return _getEmojiForWeatherCode(data.current.weatherCode);
}
```

### Elevation API (Open-Elevation)
**Endpoint:** `https://api.open-elevation.com/api/v1/lookup`

**Parameters:**
- locations (array of {latitude, longitude})

**Implementation:**
```dart
// ElevationService
Future<ElevationResponse> getElevationByCoordinates(List<Map<String, double>> locations) async {
  final response = await http.post(
    Uri.parse('https://api.open-elevation.com/api/v1/lookup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'locations': locations}),
  );
  // ... parsing & error handling
}

// ElevationRepository - Difficulty Level
String getDifficultyLevel(double elevation) {
  if (elevation < 500) return 'Easy';
  else if (elevation < 1500) return 'Moderate';
  else return 'Hard';
}
```

## 🎨 Design System

### Color Palette
- **Primary Background:** #0F0F1E (Dark Navy)
- **Secondary Background:** #1A1A2E (Dark Blue)
- **Primary Accent:** #6366F1 (Indigo)
- **Secondary Accent:** #8B5CF6 (Purple)
- **Highlight:** #FFA500 (Orange)
- **Text Primary:** #FFFFFF (White)
- **Text Secondary:** #A0A0A0 (Gray)
- **Success:** #10B981 (Green)
- **Error:** #EF4444 (Red)

### Typography
- **Heading:** Segoe UI Bold (700-800 weight), 20-24px
- **Body:** Segoe UI Regular (400 weight), 14-16px
- **Caption:** Segoe UI Regular (400 weight), 10-12px
- **Timer/Mono:** Monospace, 48px

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  google_maps_flutter: ^2.5.0        # Maps integration
  geolocator: ^9.0.2                 # GPS tracking
  shared_preferences: ^2.2.0         # Local data storage
  http: ^1.1.0                       # HTTP client for APIs
  image_picker: ^0.8.9               # Profile photo upload
```

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter 3.9.0+
- Dart 3.0+
- Android SDK 33+ atau iOS 12+

### Setup
1. Clone repository
   ```bash
   git clone https://github.com/BintangS4/Mobile-Programming.git
   cd Mobile-Programming/uas
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run aplikasi
   ```bash
   flutter run
   ```

### Testing Features
1. **Dashboard:**
   - Lihat user greeting & weekly goal
   - Tap settings icon untuk edit weekly goal

2. **Running/Hiking Page:**
   - Lihat real-time weather dari Open-Meteo API
   - Scroll untuk lihat elevation (Open-Elevation API)
   - Tap location untuk enable GPS tracking
   - Save activity untuk simpan ke SharedPreferences

3. **Profile Page:**
   - Tap camera icon untuk upload profile photo
   - Edit nama dengan Edit Profile button
   - Lihat dynamic level (auto-calculated dari total distance)
   - Search activities by type/date/distance
   - Filter dengan buttons (All/Running/Hiking)
   - Tap delete icon untuk hapus activity

## 🧪 Testing Scenarios

### API Integration
1. **Weather API Test:**
   - Jalankan app dengan internet connection
   - Buka Running/Hiking page
   - Verifikasi weather widget menampilkan data dari Open-Meteo
   - Cek emoji sesuai kondisi cuaca

2. **Elevation API Test:**
   - Scroll down di Running/Hiking page
   - Verifikasi elevation data dari Open-Elevation API
   - Cek difficulty level calculation

3. **Error Handling Test:**
   - Disable internet connection
   - Weather/Elevation widget harus menampilkan error message
   - App tetap berfungsi dengan graceful degradation

### Search & Filter
1. **Search Test:**
   - Ke Profile page
   - Type "running" di search bar → filter by type
   - Type tanggal → filter by date
   - Type jarak → filter by distance

2. **Filter Buttons Test:**
   - Click "Running" button → only running activities
   - Click "Hiking" button → only hiking activities
   - Click "All" button → semua activities

### Profile Features
1. **Photo Upload:**
   - Tap camera icon
   - Select image dari gallery
   - Verifikasi image ditampilkan di profile avatar

2. **Dynamic Level:**
   - Save beberapa activities
   - Lihat total distance dihitung
   - Verifikasi level berubah sesuai total distance (Level 1-6)

3. **Weekly Goal:**
   - Tap settings icon di home page
   - Edit weekly goal (misal 100 km)
   - Data persisten di SharedPreferences

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────┐
│                   UI LAYER                      │
├─────────────────────────────────────────────────┤
│ HomePage | RunningPage | HikingPage | Profile   │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│             REPOSITORY LAYER                    │
├─────────────────────────────────────────────────┤
│ WeatherRepository  │  ElevationRepository       │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│              SERVICE LAYER                      │
├─────────────────────────────────────────────────┤
│ WeatherService (Open-Meteo) │ ElevationService  │
│                (Open-Elevation)                 │
└─────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────┐
│            EXTERNAL APIs                        │
├─────────────────────────────────────────────────┤
│ Open-Meteo Weather API │ Open-Elevation API     │
└─────────────────────────────────────────────────┘
```

## ⚡ Performance Optimization

1. **API Caching:** Weather data cache untuk 10 menit
2. **Async Loading:** FutureBuilder dengan timeout handling
3. **Image Optimization:** Profile photos compressed sebelum saved
4. **Efficient Filtering:** Real-time search tanpa query database

## 🔒 Error Handling

```dart
// API Error Handling
try {
  final weather = await _weatherRepository.getWeatherByCoordinate(lat, lng);
} on WeatherException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Weather API Error: ${e.message}')),
  );
}

// Network Timeout Handling
http.Client().get(uri).timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw TimeoutException('API timeout'),
);
```

## 📝 Git Branches

- **main:** UTS version (initial submission)
- **uas:** UAS version (dengan API integration & advanced features)

## 👤 Author

**Bintang Syachriza Akbar**
- NIM: 230605110061
- Kelas: E
- Universitas Islam Negeri Maulana Malik Ibrahim Malang

---

**Last Updated:** December 11, 2025
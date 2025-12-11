class TrackingSession {
  final String id;
  final String type; // 'running' atau 'hiking'
  DateTime startTime;
  DateTime? endTime;
  int elapsedSeconds; // real-time elapsed time
  double distance; // dalam km
  int calories; // dalam kcal
  double speed; // dalam km/h
  double? elevation; // dalam meter (untuk hiking)
  List<Map<String, double>> coordinates; // latitude, longitude points

  TrackingSession({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    this.elapsedSeconds = 0,
    this.distance = 0.0,
    this.calories = 0,
    this.speed = 0.0,
    this.elevation,
    this.coordinates = const [],
  });

  bool get isActive => endTime == null;

  void updateElapsedSeconds() {
    if (isActive) {
      elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
    }
  }

  factory TrackingSession.fromJson(Map<String, dynamic> json) {
    return TrackingSession(
      id: json['id'],
      type: json['type'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
      distance: (json['distance'] as num).toDouble(),
      calories: json['calories'],
      speed: (json['speed'] as num).toDouble(),
      elevation: json['elevation']?.toDouble(),
      coordinates: List<Map<String, double>>.from(
        (json['coordinates'] as List<dynamic>? ?? []).map(
          (coord) => Map<String, double>.from(coord),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'elapsedSeconds': elapsedSeconds,
    'distance': distance,
    'calories': calories,
    'speed': speed,
    'elevation': elevation,
    'coordinates': coordinates,
  };
}

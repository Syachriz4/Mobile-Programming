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
  String name; // custom session name
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
    this.name = '',
    this.coordinates = const [],
  });

  bool get isActive => endTime == null;
  
  int get durationSeconds => endTime != null 
      ? endTime!.difference(startTime).inSeconds 
      : DateTime.now().difference(startTime).inSeconds;
  
  String get formattedDuration {
    final seconds = durationSeconds;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

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
      name: json['name'] ?? '',
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
    'name': name,
    'coordinates': coordinates,
  };
}

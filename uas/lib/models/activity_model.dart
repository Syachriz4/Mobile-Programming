class Activity {
  final String id;
  final String type; // 'running' atau 'hiking'
  final double distance; // dalam km
  final int duration; // dalam detik
  final int calories; // dalam kcal
  final double speed; // dalam km/h
  final String date;
  final double? elevation; // dalam meter (nullable)

  Activity({
    required this.id,
    required this.type,
    required this.distance,
    required this.duration,
    required this.calories,
    required this.speed,
    required this.date,
    this.elevation,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      type: json['type'],
      distance: json['distance'].toDouble(),
      duration: json['duration'],
      calories: json['calories'],
      speed: json['speed'].toDouble(),
      date: json['date'],
      elevation: json['elevation']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'distance': distance,
      'duration': duration,
      'calories': calories,
      'speed': speed,
      'date': date,
      'elevation': elevation,
    };
  }
}
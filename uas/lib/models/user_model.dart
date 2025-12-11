class UserProfile {
  final String id;
  final String name;
  final String avatar;
  final String level;
  final int levelNumber;
  final double totalRunDistance; // dalam km
  final double totalHikeDistance; // dalam km
  final int totalCalories; // dalam kcal
  final DateTime joinDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.levelNumber,
    required this.totalRunDistance,
    required this.totalHikeDistance,
    required this.totalCalories,
    required this.joinDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      level: json['level'],
      levelNumber: json['levelNumber'],
      totalRunDistance: (json['totalRunDistance'] as num).toDouble(),
      totalHikeDistance: (json['totalHikeDistance'] as num).toDouble(),
      totalCalories: json['totalCalories'],
      joinDate: DateTime.parse(json['joinDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'level': level,
    'levelNumber': levelNumber,
    'totalRunDistance': totalRunDistance,
    'totalHikeDistance': totalHikeDistance,
    'totalCalories': totalCalories,
    'joinDate': joinDate.toIso8601String(),
  };
}

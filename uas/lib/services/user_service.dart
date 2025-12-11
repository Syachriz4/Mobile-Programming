import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _nameKey = 'user_name';
  static const String _initialsKey = 'user_initials';
  static const String _levelKey = 'user_level';
  static const String _imagePathKey = 'user_image_path';
  static const String _weeklyGoalKey = 'weekly_goal';

  // Default values
  static const String defaultName = 'Andrew';
  static const String defaultInitials = 'AS';
  static const String defaultLevel = 'Beginner';
  static const double defaultWeeklyGoal = 50.0;

  // Get user name
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? defaultName;
  }

  // Get user initials
  static Future<String> getUserInitials() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_initialsKey) ?? defaultInitials;
  }

  // Get user level
  static Future<String> getUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_levelKey) ?? defaultLevel;
  }

  // Get user image path
  static Future<String?> getUserImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imagePathKey);
  }

  // Get weekly goal
  static Future<double> getWeeklyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_weeklyGoalKey) ?? defaultWeeklyGoal;
  }

  // Save user name
  static Future<bool> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_nameKey, name);
  }

  // Save user initials
  static Future<bool> saveUserInitials(String initials) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_initialsKey, initials);
  }

  // Save user level
  static Future<bool> saveUserLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_levelKey, level);
  }

  // Save user image path
  static Future<bool> saveUserImagePath(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (imagePath == null) {
      return prefs.remove(_imagePathKey);
    }
    return prefs.setString(_imagePathKey, imagePath);
  }

  // Save weekly goal
  static Future<bool> saveWeeklyGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(_weeklyGoalKey, goal);
  }

  // Save all user data at once
  static Future<void> saveUserData({
    required String name,
    required String initials,
    String? imagePath,
  }) async {
    await saveUserName(name);
    await saveUserInitials(initials);
    if (imagePath != null) {
      await saveUserImagePath(imagePath);
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_initialsKey);
    await prefs.remove(_levelKey);
    await prefs.remove(_imagePathKey);
  }
}

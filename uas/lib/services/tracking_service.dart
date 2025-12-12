import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tracking_session_model.dart';

class TrackingService {
  static const String _storageKey = 'tracking_sessions';
  
  // Calculate distance between two coordinates in km using Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) * math.cos(_toRad(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadiusKm * c;
    
    return distance;
  }
  
  static double _toRad(double degree) {
    return degree * 3.14159265359 / 180;
  }

  // Save tracking session
  static Future<void> saveTrackingSession(TrackingSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await getAllSessions();
      sessions.add(session);
      
      final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList(_storageKey, jsonList);
    } catch (e) {
      print('Error saving tracking session: $e');
    }
  }

  // Get all tracking sessions
  static Future<List<TrackingSession>> getAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_storageKey) ?? [];
      
      return jsonList
          .map((json) => TrackingSession.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading tracking sessions: $e');
      return [];
    }
  }

  // Get sessions by type
  static Future<List<TrackingSession>> getSessionsByType(String type) async {
    final sessions = await getAllSessions();
    return sessions.where((s) => s.type == type).toList();
  }

  // Delete session
  static Future<void> deleteSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var sessions = await getAllSessions();
      sessions.removeWhere((s) => s.id == sessionId);
      
      final jsonList = sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList(_storageKey, jsonList);
    } catch (e) {
      print('Error deleting tracking session: $e');
    }
  }

  // Get stats summary
  static Future<Map<String, dynamic>> getStatsSummary(String type) async {
    final sessions = await getSessionsByType(type);
    
    double totalDistance = 0;
    int totalSeconds = 0;
    int totalSessions = sessions.length;
    
    for (var session in sessions) {
      totalDistance += session.distance;
      if (session.endTime != null) {
        totalSeconds += session.endTime!.difference(session.startTime).inSeconds;
      }
    }
    
    return {
      'totalDistance': totalDistance,
      'totalDuration': totalSeconds,
      'totalSessions': totalSessions,
      'avgDistance': totalSessions > 0 ? totalDistance / totalSessions : 0,
    };
  }
}

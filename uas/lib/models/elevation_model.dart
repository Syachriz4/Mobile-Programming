class ElevationData {
  final double elevation;
  final double latitude;
  final double longitude;

  ElevationData({
    required this.elevation,
    required this.latitude,
    required this.longitude,
  });

  factory ElevationData.fromJson(Map<String, dynamic> json) {
    return ElevationData(
      elevation: (json['elevation'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class ElevationResponse {
  final List<ElevationData> results;

  ElevationResponse({required this.results});

  factory ElevationResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> results = json['results'] ?? [];
    return ElevationResponse(
      results: results.map((e) => ElevationData.fromJson(e)).toList(),
    );
  }
}

class ElevationException implements Exception {
  final String message;
  ElevationException(this.message);

  @override
  String toString() => message;
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../repositories/weather_repository.dart';
import '../repositories/elevation_repository.dart';
import '../services/tracking_service.dart';
import '../models/tracking_session_model.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  
  // Map Controller
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};
  double _currentLat = -6.200000; // Default: Jakarta
  double _currentLng = 106.816666;
  double _lastTrackedLat = 0;
  double _lastTrackedLng = 0;
  StreamSubscription<Position>? _positionStream;
  TrackingSession? _currentSession;
  List<LatLng> _routePoints = [];
  
  // Current stats
  double _distance = 0.0;
  double _speed = 0.0;
  double _elevation = 0.0; // mdpl from API
  String _temperature = '--';
  String _weatherCondition = '--';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request location permission first
      final permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });
      
      // Load elevation and weather for current position
      await Future.wait([
        _loadElevation(position.latitude, position.longitude),
        _loadWeatherAndElevation(),
      ]);
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherAndElevation() async {
    try {
      final repository = WeatherRepository();
      final weather = await repository.getWeatherByCoordinate(
        _currentLat,
        _currentLng,
      );
      
      final condition = repository.getWeatherCondition(weather.weatherCode);
      
      setState(() {
        _temperature = '${weather.temperature.round()}°C';
        _weatherCondition = condition;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading weather: $e');
      setState(() {
        _temperature = 'N/A';
        _weatherCondition = 'Unable to load';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadElevation(double latitude, double longitude) async {
    try {
      final repository = ElevationRepository();
      final elevation = await repository.getElevationByCoordinate(
        latitude,
        longitude,
      );
      
      setState(() {
        _elevation = elevation;
      });
    } catch (e) {
      print('Error loading elevation: $e');
      setState(() {
        _elevation = 0.0;
      });
    }
  }

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
      _positionStream?.cancel();
      _endRunning();
    }
    super.dispose();
  }

  Future<void> _startGpsTracking() async {
    _lastTrackedLat = _currentLat;
    _lastTrackedLng = _currentLng;
    _routePoints = [LatLng(_currentLat, _currentLng)];
    
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });
      
      final distance = TrackingService.calculateDistance(
        _lastTrackedLat,
        _lastTrackedLng,
        position.latitude,
        position.longitude,
      );
      
      if (distance > 0.0005) {
        setState(() {
          _distance += distance;
          _lastTrackedLat = position.latitude;
          _lastTrackedLng = position.longitude;
          
          // Add to route points for polyline
          _routePoints.add(LatLng(position.latitude, position.longitude));
          
          // Update polyline
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: _routePoints,
              color: Colors.indigo,
              width: 5,
              geodesic: true,
            )
          };
        });
        
        if (_currentSession != null) {
          _currentSession!.coordinates.add({
            'latitude': position.latitude,
            'longitude': position.longitude,
          });
          _currentSession!.distance = _distance;
        }
      }
    });
  }

  Future<void> _endRunning() async {
    if (_currentSession != null) {
      _currentSession!.endTime = DateTime.now();
      _currentSession!.distance = _distance;
      _currentSession!.speed = _distance > 0 && _elapsedSeconds > 0 
          ? (_distance / (_elapsedSeconds / 3600)) 
          : 0;
      
      // Calculate calories: running ~100 kcal per km (varies by speed & weight)
      _currentSession!.calories = (_distance * 100).toInt();
      
      await TrackingService.saveTrackingSession(_currentSession!);
      _currentSession = null;
    }
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _currentSession = TrackingSession(
        id: const Uuid().v4(),
        type: 'Running',
        startTime: DateTime.now(),
        distance: 0,
        speed: 0,
        elevation: _elevation,
        coordinates: [
          {'latitude': _currentLat, 'longitude': _currentLng}
        ],
      );
      
      _polylines = {};
      _routePoints = [];
      
      _startGpsTracking();
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          if (_elapsedSeconds > 0) {
            _speed = (_distance / (_elapsedSeconds / 3600));
          }
        });
      });
    } else {
      _timer.cancel();
      _positionStream?.cancel();
      _endRunning();
      _distance = 0;
      _speed = 0;
      _elapsedSeconds = 0;
      _polylines = {};
      _routePoints = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate time components
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    final hours = minutes ~/ 60;
    final displayMinutes = minutes % 60;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 22),
            
            // Weather Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Temperature',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _temperature,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Icon(Icons.cloud, size: 40, color: Colors.white70),
                        const SizedBox(height: 8),
                        Text(
                          _weatherCondition,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Google Map
            Container(
              height: 350,
              color: Colors.grey.shade800,
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.indigo),
                    )
                  : GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentLat, _currentLng),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      polylines: _polylines,
                    ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 5),
              child: Column(
                children: [
                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: [
                      _buildStatBox('📍', _distance.toStringAsFixed(2), 'km'),
                      _buildStatBox('🏔️', _elevation.toStringAsFixed(0), 'mdpl'),
                      _buildStatBox('⚡', _speed.toStringAsFixed(1), 'km/h'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Large Timer Display
                  Text(
                    '${hours.toString().padLeft(2, '0')}:${displayMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start/Stop Button
                  GestureDetector(
                    onTap: _toggleRunning,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build stat boxes
  Widget _buildStatBox(String icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 26), // icon lebih besar
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16, // value lebih besar
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12, // label sedikit lebih besar
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';

class HikingPage extends StatefulWidget {
  const HikingPage({super.key});

  @override
  State<HikingPage> createState() => _HikingPageState();
}

class _HikingPageState extends State<HikingPage> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  
  // Current stats
  double _distance = 0.0;
  double _speed = 0.0;
  double _elevation = 12.0; // mdpl
  String _temperature = '28.5°C';
  String _weatherCondition = 'Partly cloudy';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _toggleHiking() {
    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedSeconds++;
          // Simulate distance, speed, and elevation
          _distance += 0.008;
          _speed = (0.008 * 3600) / 1000; // km/h
          _elevation += 0.5; // Simulate altitude gain
        });
      });
    } else {
      _timer.cancel();
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
            // Google Maps
            Container(
              height: 250,
              color: Colors.grey.shade800,
              child: Stack(
                children: [
                  // Placeholder for Google Maps
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade700,
                          Colors.grey.shade800,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Map View',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Location marker simulation
                  Positioned(
                    top: 60,
                    left: 120,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Weather Card
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple.withOpacity(0.3)),
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
                  const SizedBox(height: 16),

                  // Stats Grid - Elevation Focus
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                    children: [
                      _buildStatBox('📍', _distance.toStringAsFixed(2), 'km'),
                      _buildStatBox('🏔️', _elevation.toStringAsFixed(0), 'm'),
                      _buildStatBox('⚡', _speed.toStringAsFixed(1), 'km/h'),
                    ],
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 24),

                  // Start/Stop Button
                  GestureDetector(
                    onTap: _toggleHiking,
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
                  const SizedBox(height: 24),

                  // Prayer/Dzikir Reminder Box
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      border: Border.all(color: Colors.purple.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📿 DZIKIR REMINDER',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isRunning ? 'Hiking in progress...' : 'Start hiking to receive dzikir reminders',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Elevation tracking...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
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
        color: Colors.purple.withOpacity(0.1),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
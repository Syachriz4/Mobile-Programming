import 'package:flutter/material.dart';

class RunningPage extends StatefulWidget {
  const RunningPage({super.key});

  @override
  State<RunningPage> createState() => _RunningPageState();
}

class _RunningPageState extends State<RunningPage> {
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate time components
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    final hours = minutes ~/ 60;
    final displayMinutes = minutes % 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Running'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.indigo.withOpacity(0.5)),
            ),
            child: const Text(
              '📍 GPS',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Map Preview
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.withOpacity(0.15),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  '🗺️ Map Preview\n(Coming Soon)',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Grid (Empty state)
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              children: [
                _buildStatBox('👟', '--', 'km'),
                _buildStatBox('🔥', '--', 'kcal'),
                _buildStatBox('⚡', '--', 'km/h'),
              ],
            ),
            const SizedBox(height: 20),

            // Large Timer Display
            Text(
              '${hours.toString().padLeft(2, '0')}:${displayMinutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),

            // Pause/Resume Button
            FloatingActionButton(
              onPressed: () {
                setState(() => _isRunning = !_isRunning);
              },
              backgroundColor: Colors.indigo,
              child: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),

            // Prayer Reminder Box
            Container(
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⏰ PRAYER REMINDER',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Start running to receive prayer reminders',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Location: Waiting for GPS...',
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
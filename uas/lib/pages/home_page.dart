import 'package:flutter/material.dart';
import 'dart:io';
import '../models/tracking_session_model.dart';
import '../services/user_service.dart';
import '../services/tracking_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TrackingSession> _allActivities = [];
  String _userName = 'Andrew';
  String _userLevel = 'Beginner';
  String _userInitials = 'AS';
  String? _userImagePath;
  double _weeklyGoal = 50.0; // km
  double _weeklyProgress = 0.0; // km done
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _loadUserData();
  }

  Future<void> _loadActivities() async {
    final activities = await TrackingService.getAllSessions();
    if (mounted) {
      setState(() {
        // Sort by start time (newest first)
        activities.sort((a, b) => b.startTime.compareTo(a.startTime));
        _allActivities = activities;
        // Calculate weekly progress
        _weeklyProgress = activities.fold(0, (sum, session) => sum + session.distance);
      });
    }
  }

  Future<void> _loadUserData() async {
    final name = await UserService.getUserName();
    final initials = await UserService.getUserInitials();
    final level = await UserService.getUserLevel();
    final imagePath = await UserService.getUserImagePath();
    final weeklyGoal = await UserService.getWeeklyGoal();
    
    if (mounted) {
      setState(() {
        _userName = name;
        _userInitials = initials;
        _userLevel = level;
        _userImagePath = imagePath;
        _weeklyGoal = weeklyGoal;
      });
    }
  }

  List<TrackingSession> _filterActivities(List<TrackingSession> activities) {
    var filtered = activities;

    // Apply filter
    if (_selectedFilter == '⚡ Running') {
      filtered = filtered.where((a) => a.type == 'Running').toList();
    } else if (_selectedFilter == '⛰️ Hiking') {
      filtered = filtered.where((a) => a.type == 'Hiking').toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        final typeLower = a.type.toLowerCase();
        final dateLower = a.startTime.toString().toLowerCase();
        final nameLower = a.name.toLowerCase();
        return typeLower.contains(_searchQuery.toLowerCase()) ||
            dateLower.contains(_searchQuery.toLowerCase()) ||
            nameLower.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6366F1)
                : Colors.white.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(TrackingSession session) {
    final durationText = session.formattedDuration;
    final dateText = _formatDate(session.startTime);
    final distanceText = session.distance.toStringAsFixed(2);
    final speedText = session.speed.toStringAsFixed(2);
    final typeEmoji = session.type == 'Running' ? '⚡' : '⛰️';
    final typeColor = session.type == 'Running' 
        ? Colors.indigo.withOpacity(0.2)
        : Colors.purple.withOpacity(0.2);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: typeColor,
        border: Border.all(
          color: session.type == 'Running' 
              ? Colors.indigo.withOpacity(0.3)
              : Colors.purple.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Text(
          typeEmoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.name.isNotEmpty ? session.name : '${session.type} Session',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateText,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildInfoChip('📍 $distanceText km'),
                const SizedBox(width: 8),
                _buildInfoChip('⏱️ $durationText'),
                const SizedBox(width: 8),
                _buildInfoChip('⚡ $speedText km/h'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'Today at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (date == yesterday) {
      return 'Yesterday at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _showSettingsDialog() {
    final TextEditingController controller = TextEditingController(
      text: _weeklyGoal.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F1E),
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Weekly Goal (km)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter weekly goal in km',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF6366F1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF6366F1)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newGoal = double.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                await UserService.saveWeeklyGoal(newGoal);
                setState(() {
                  _weeklyGoal = newGoal;
                });
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weekly goal updated successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid number'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFF0A0E27),
            title: const Text('RunHike Islami'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // User Greeting Card
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF6366F1),
                      backgroundImage: _userImagePath != null && File(_userImagePath!).existsSync()
                          ? FileImage(File(_userImagePath!))
                          : null,
                      child: _userImagePath != null && File(_userImagePath!).existsSync()
                          ? null
                          : Text(
                              _userInitials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $_userName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _userLevel,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () => _showSettingsDialog(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Weekly Goal Card
                _buildWeeklyGoalCard(),
                const SizedBox(height: 18),

                // Recent Activity Section Header
                const Text(
                  '📍 RECENT ACTIVITY',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search activities...',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF6366F1)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('⚡ Running'),
                      const SizedBox(width: 8),
                      _buildFilterChip('⛰️ Hiking'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Activity List
                _allActivities.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No activities found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : Builder(
                        builder: (context) {
                          final filteredActivities = _filterActivities(_allActivities);

                          if (filteredActivities.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No activities match your search'
                                      : 'No activities for this filter',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredActivities.length,
                            itemBuilder: (context, index) {
                              final session = filteredActivities[index];
                              return _buildSessionCard(session);
                            },
                          );
                        },
                      ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withOpacity(0.2),
            Colors.purple.withOpacity(0.15),
          ],
        ),
        border: Border.all(
          color: Colors.indigo.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Weekly Goal',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_weeklyGoal.toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '→',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: _weeklyProgress / _weeklyGoal,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(
                Colors.indigo.shade300,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '✅ ${_weeklyProgress.toStringAsFixed(1)} km done',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              Text(
                '${(_weeklyGoal - _weeklyProgress).toStringAsFixed(1)} km left',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
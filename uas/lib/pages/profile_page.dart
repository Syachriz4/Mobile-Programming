import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tracking_session_model.dart';
import '../services/user_service.dart';
import '../services/tracking_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedFilter = 'All';
  List<TrackingSession> _trackingSessions = [];
  String _userName = 'User';
  String _userInitials = '--';
  String? _userImagePath;
  String _userLevel = 'Beginner';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTrackingSessions();
  }

  Future<void> _loadUserData() async {
    final name = await UserService.getUserName();
    final initials = await UserService.getUserInitials();
    final imagePath = await UserService.getUserImagePath();
    final level = await UserService.getUserLevel();
    
    if (mounted) {
      setState(() {
        _userName = name;
        _userInitials = initials;
        _userImagePath = imagePath;
        _userLevel = level;
      });
    }
  }

  Future<void> _loadTrackingSessions() async {
    final sessions = await TrackingService.getAllSessions();
    if (mounted) {
      setState(() {
        // Sort by start time (newest first)
        _trackingSessions = sessions;
        _trackingSessions.sort((a, b) => b.startTime.compareTo(a.startTime));
      });
    }
  }

  List<TrackingSession> _getFilteredSessions() {
    var filtered = _trackingSessions;
    
    // Apply type filter
    if (_selectedFilter == '⚡ Running') {
      filtered = filtered.where((s) => s.type == 'Running').toList();
    } else if (_selectedFilter == '⛰️ Hiking') {
      filtered = filtered.where((s) => s.type == 'Hiking').toList();
    }
    
    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) {
        final dateStr = s.startTime.toString();
        final distanceStr = s.distance.toStringAsFixed(2);
        final query = _searchQuery.toLowerCase();
        
        return s.type.toLowerCase().contains(query) ||
            dateStr.toLowerCase().contains(query) ||
            distanceStr.contains(query);
      }).toList();
    }
    
    return filtered;
  }

  String _getRunningDistance() {
    final runningTotal = _trackingSessions
        .where((s) => s.type == 'Running')
        .fold<double>(0.0, (sum, s) => sum + s.distance);
    return runningTotal.toStringAsFixed(1);
  }

  String _getHikingDistance() {
    final hikingTotal = _trackingSessions
        .where((s) => s.type == 'Hiking')
        .fold<double>(0.0, (sum, s) => sum + s.distance);
    return hikingTotal.toStringAsFixed(1);
  }

  String _getTotalCalories() {
    final totalCals = _trackingSessions
        .fold<int>(0, (sum, s) => sum + s.calories);
    return totalCals.toString();
  }

  String _getLevelEmoji(String level) {
    switch (level) {
      case 'Beginner':
        return '🌱';
      case 'Intermediate':
        return '🔥';
      case 'Advanced':
        return '⚡';
      case 'Expert':
        return '👑';
      case 'Master':
        return '💎';
      default:
        return '🌱';
    }
  }

  void _showEditSessionDialog(TrackingSession session) {
    final nameController = TextEditingController(text: session.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F1E),
        title: Text(
          'Edit ${session.type} Session',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Session Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Session Name',
                  labelStyle: const TextStyle(color: Colors.grey),
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
                    borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              
              // Display tracking data as read-only
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distance: ${session.distance.toStringAsFixed(2)} km',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Speed: ${session.speed.toStringAsFixed(2)} km/h',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calories: ${session.calories} kcal',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (session.elevation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Elevation: ${session.elevation!.toStringAsFixed(0)} m',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'These values are calculated from GPS tracking and cannot be edited.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              // Update session name
              session.name = nameController.text;
              
              // Save updated session
              final allSessions = await TrackingService.getAllSessions();
              final index = allSessions.indexWhere((s) => s.id == session.id);
              if (index != -1) {
                allSessions[index] = session;
                
                // Save all sessions
                final jsonList = allSessions
                    .map((s) => jsonEncode(s.toJson()))
                    .toList();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('tracking_sessions', jsonList);
              }
              
              if (mounted) {
                Navigator.pop(context);
                _loadTrackingSessions();
              }
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFF6366F1))),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSession(String sessionId) async {
    await TrackingService.deleteSession(sessionId);
    _loadTrackingSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFF0A0E27),
            title: const Text('Profile'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF6366F1),
                        backgroundImage: _userImagePath != null && File(_userImagePath!).existsSync()
                            ? FileImage(File(_userImagePath!))
                            : null,
                        child: _userImagePath != null && File(_userImagePath!).existsSync()
                            ? null
                            : Text(
                                _userInitials,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // User Name Display
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // User Level Display
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF6366F1).withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getLevelEmoji(_userLevel),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _userLevel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Edit Profile Button
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                initialName: _userName,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _userName = result['name'] ?? _userName;
                              _userInitials = result['initials'] ?? _userInitials;
                              _userImagePath = result['imagePath'] ?? _userImagePath;
                              _userLevel = result['level'] ?? _userLevel;
                            });
                          }
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Statistics Section
                const Text(
                  'STATISTICS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                  children: [
                    _buildStatCard('🏃', _getRunningDistance(), 'km Run'),
                    _buildStatCard('⛰️', _getHikingDistance(), 'km Hike'),
                    _buildStatCard('🔥', _getTotalCalories(), 'kcal'),
                  ],
                ),
                const SizedBox(height: 32),

                // Saved Activities Section
                const Text(
                  'SAVED ACTIVITIES',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search activities (type, date, distance)...',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

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

                // Activities List or Empty State
                if (_getFilteredSessions().isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No activities yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _getFilteredSessions().length,
                    itemBuilder: (context, index) {
                      final session = _getFilteredSessions()[index];
                      return _buildSessionCard(session);
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

  // Helper method to build stat card
  Widget _buildStatCard(String icon, String value, String label) {
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
            style: const TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method to build session card
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
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditSessionDialog(session);
            } else if (value == 'delete') {
              _deleteSession(session.id);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
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
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  // Helper method to build filter chip
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
}
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                        radius: 40,
                        backgroundColor: const Color(0xFF6366F1),
                        child: const Text(
                          'AS',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Andrew Sinclair',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Beginner • Level 5',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
                    _buildStatCard('🏃', '45.5', 'km Run'),
                    _buildStatCard('⛰️', '38.9', 'km Hike'),
                    _buildStatCard('🔥', '4,200', 'kcal'),
                  ],
                ),
                const SizedBox(height: 24),

                // Menu Section
                const Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItem('⚙️', 'Personal Parameters'),
                _buildMenuItem('🏆', 'Achievements'),
                _buildMenuItem('📚', 'Islamic Content'),
                _buildMenuItem('🔧', 'Settings'),
                _buildMenuItem('📞', 'Contact & Support'),
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

  // Helper method to build menu item
  Widget _buildMenuItem(String icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Text(
            '›',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
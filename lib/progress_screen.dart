import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Progress screen — UI only. Date selector, colored stat cards, recent activity.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Today'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 28),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _days.map((day) {
          final isToday = day == 'Today';
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              day,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                color: isToday ? navSelected : textMuted,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildColoredStatCard(
                icon: Icons.local_fire_department_rounded,
                value: '12',
                label: 'Day Streak',
                color: statusGood,
              ),
              const SizedBox(height: 12),
              _buildColoredStatCard(
                icon: Icons.schedule_rounded,
                value: '142',
                label: 'Minutes Practiced',
                color: navSelected,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _buildColoredStatCard(
                icon: Icons.fitness_center_rounded,
                value: '38',
                label: 'Exercises Done',
                color: tipCardPurple,
              ),
              const SizedBox(height: 12),
              _buildColoredStatCard(
                icon: Icons.emoji_emotions_rounded,
                value: '87%',
                label: 'Good Days',
                color: quickVisualization,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColoredStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          icon: Icons.refresh_rounded,
          iconColor: navSelected,
          iconBgColor: navSelected.withValues(alpha: 0.15),
          title: 'Box Breathing',
          subtitle: '2 hours ago',
          duration: '3 min',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.checklist_rounded,
          iconColor: tipCardPurple,
          iconBgColor: tipCardPurple.withValues(alpha: 0.15),
          title: 'Mental Check-In',
          subtitle: '5 hours ago',
          duration: '2 min',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.visibility_rounded,
          iconColor: quickVisualization,
          iconBgColor: quickVisualization.withValues(alpha: 0.15),
          title: 'Visualization',
          subtitle: 'Yesterday',
          duration: '5 min',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String duration,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 13, color: textMuted)),
              ],
            ),
          ),
          Text(duration, style: TextStyle(fontSize: 14, color: textMuted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

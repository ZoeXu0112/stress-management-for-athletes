import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Exercises screen — UI only.
class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildRecommendedCard(),
            const SizedBox(height: 28),
            _buildAllTechniquesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercises',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 6),
        Text(
          'Evidence-based techniques to calm your mind.',
          style: TextStyle(fontSize: 16, color: textMuted),
        ),
      ],
    );
  }

  Widget _buildRecommendedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tipCardPurple, navSelected],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: tipCardPurple.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Recommended', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Text(
            'Pre-Performance Breathing',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '4-7-8 technique to reduce anxiety before skating.',
            style: TextStyle(fontSize: 14, height: 1.4, color: Colors.white.withValues(alpha: 0.95)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, size: 18, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 6),
              Text('5 min', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.95))),
              const SizedBox(width: 20),
              Icon(Icons.bar_chart_rounded, size: 18, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 6),
              Text('Beginner', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.95))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: navSelected,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Start Exercise'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTechniquesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Techniques',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
        ),
        const SizedBox(height: 16),
        _buildTechniqueRow(
          icon: Icons.air_rounded,
          iconBgColor: quickMeditation.withValues(alpha: 0.25),
          title: 'Box Breathing',
          description: 'Rhythmic breathing for focus',
          duration: '3 min',
          hasAudio: true,
          onPlay: () {},
        ),
        const SizedBox(height: 12),
        _buildTechniqueRow(
          icon: Icons.psychology_rounded,
          iconBgColor: quickVisualization.withValues(alpha: 0.25),
          title: 'Progressive Muscle Relaxation',
          description: 'Release physical tension',
          duration: '10 min',
          hasAudio: true,
          onPlay: () {},
        ),
      ],
    );
  }

  Widget _buildTechniqueRow({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String description,
    required String duration,
    required bool hasAudio,
    required VoidCallback onPlay,
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
            child: Icon(icon, color: tipCardPurple, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 13, color: textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: textMuted),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(fontSize: 12, color: textMuted)),
                    if (hasAudio) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.headphones_rounded, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text('Audio guided', style: TextStyle(fontSize: 12, color: textMuted)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: textMuted.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.play_arrow_rounded, size: 32, color: textDark),
          ),
        ],
      ),
    );
  }
}

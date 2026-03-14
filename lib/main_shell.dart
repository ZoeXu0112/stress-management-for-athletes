import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';
import 'package:stress_management_by_zoe/home/homescreen.dart';
import 'package:stress_management_by_zoe/check_in_screen.dart';
import 'package:stress_management_by_zoe/exercises_screen.dart';
import 'package:stress_management_by_zoe/progress_screen.dart';
import 'package:stress_management_by_zoe/profile_screen.dart';

/// Shell that shows the selected tab content and a shared bottom bar.
/// Tapping a tab switches the visible screen.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const Homescreen();
      case 1:
        return const CheckInScreen();
      case 2:
        return const ExercisesScreen();
      case 3:
        return const ProgressScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const Homescreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(child: _buildCurrentScreen()),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.checklist_rounded, 'Check-in'),
              _buildNavItem(2, Icons.fitness_center_rounded, 'Exercises'),
              _buildNavItem(3, Icons.show_chart_rounded, 'Progress'),
              _buildNavItem(4, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? navSelected : navUnselected,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? navSelected : navUnselected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

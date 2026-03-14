import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Check-in questionnaire screen — UI only.
class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestion(),
                  const SizedBox(height: 32),
                  _buildOptionCards(),
                  const SizedBox(height: 40),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question 2 of 4', style: TextStyle(fontSize: 14, color: textMuted, fontWeight: FontWeight.w500)),
              Text('50%', style: TextStyle(fontSize: 14, color: textMuted, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: textMuted.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(navSelected),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Over the past week, how often have you felt nervous or anxious about your performance?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark, height: 1.3),
        ),
        const SizedBox(height: 12),
        Text('Select the option that best describes your experience', style: TextStyle(fontSize: 14, color: textMuted)),
      ],
    );
  }

  Widget _buildOptionCards() {
    const int selectedIndex = 1;
    final options = [
      ('Not at all', '0 days'),
      ('Several days', '1-3 days'),
      ('More than half the days', '4-5 days'),
      ('Nearly every day', '6-7 days'),
    ];
    return Column(
      children: List.generate(options.length, (index) {
        final isSelected = index == selectedIndex;
        final (label, subtitle) = options[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionCard(label: label, subtitle: subtitle, isSelected: isSelected, onTap: () {}),
        );
      }),
    );
  }

  Widget _buildOptionCard({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? navSelected : Colors.transparent, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textDark)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: textMuted)),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? navSelected : textMuted.withValues(alpha: 0.5), width: 2),
                  color: isSelected ? navSelected : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: textMuted.withValues(alpha: 0.12),
              foregroundColor: textDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: textMuted.withValues(alpha: 0.3)),
            ),
            child: const Text('← Back'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: navSelected,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Next →'),
          ),
        ),
      ],
    );
  }
}

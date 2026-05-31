import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Grounding techniques: physical senses and mental anchors to stay present.
class GroundingScreen extends StatelessWidget {
  const GroundingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Grounding',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Come back to here and now',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Grounding is a way to anchor attention in the present: first through touch and temperature, then through simple mental tasks. Pick one that fits where you are right now.',
                style: TextStyle(
                  fontSize: 15,
                  color: textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 28),
              _buildSectionHeading('Through your body', Icons.back_hand_rounded),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '1',
                title: 'Tune in through touch',
                body:
                    'Choose something nearby with a surface you can really feel—a sleeve, desk edge, pocket item, small rock. Spend a minute noticing grain, softness, weight, warmth. You can silently put it into words: “rough,” “cool,” “tight weave.”',
              ),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '2',
                title: 'Feel the floor',
                body:
                    'Stand or sit without shoes if you can. Register pressure, coolness, softness—tile, rug, soil, whatever is under you. Stepping outdoors for a moment can sharpen that sense of place; if you stay inside, the point is still the same: notice contact, not the story in your head.',
              ),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '3',
                title: 'Use hot or cold',
                body:
                    'Let temperature pull you into the body: hands around a mug, a cool glass, chilled keys, ice wrapped in cloth. Stay with the spread of warmth or chill, how long it lasts, how your skin responds.',
              ),
              const SizedBox(height: 28),
              _buildSectionHeading('Through your attention', Icons.psychology_rounded),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '1',
                title: 'Narrate the room',
                body:
                    'Shift your gaze slowly and name five things you see—not judging, just labeling. Add colour, line, shine, matte. (“Grey vent, chipped paint, fluorescent strip.”) Detail keeps worrying thoughts from hogging the whole stage.',
              ),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '2',
                title: 'Give your mind a number job',
                body:
                    'Count down from ninety-nine by threes, or pick a silly category and tally: sockets, rectangles, plants, anything repetitive and neutral. The goal is steady focus, not getting the count perfect.',
              ),
              const SizedBox(height: 12),
              _buildTechniqueCard(
                step: '3',
                title: 'State what you know is true',
                body:
                    'Quietly list stable facts: your full name, today’s date, city you’re in, the next meal you’ll eat, one line of a song you like. You’re steering attention toward solid ground, not solving every problem at once.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: quickGrounding.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: quickGrounding, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTechniqueCard({
    required String step,
    required String title,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: quickGrounding.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              step,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: quickGrounding,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

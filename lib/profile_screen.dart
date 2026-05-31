import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stress_management_by_zoe/constants.dart';
import 'package:stress_management_by_zoe/profile_avatar_storage.dart';

/// Profile page built from the same design trends as Home, Check-in, Exercises, and Progress.
/// Shows a mood/emotion graph over Day, Week, Month, or Year (UI only, placeholder data).
enum _TimeRange { day, week, month, year }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _TimeRange _selectedRange = _TimeRange.week;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocalAvatar());
  }

  Future<void> _loadLocalAvatar() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final bytes = await loadLocalProfileAvatarBytes(uid);
    if (mounted) setState(() => _avatarBytes = bytes);
  }

  Future<void> _pickProfileImage(String uid) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 88,
    );
    if (file == null || !mounted) return;
    await saveLocalProfileAvatarFromPicker(uid, file);
    await _loadLocalAvatar();
  }

  Future<void> _showEditNameDialog(String uid, String? currentName) async {
    final controller = TextEditingController(text: currentName ?? '');
    try {
      final submitted = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Your name', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'How should we call you?',
              hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.8)),
              filled: true,
              fillColor: textMuted.withValues(alpha: 0.08),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: navSelected, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: TextStyle(color: textMuted)),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: navSelected),
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (submitted != true || !mounted) return;
      final name = controller.text.trim();
      try {
        await FirebaseFirestore.instance.collection('Users').doc(uid).set(
          name.isEmpty ? {'name': FieldValue.delete()} : {'name': name},
          SetOptions(merge: true),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not save name: $e'), behavior: SnackBarBehavior.floating),
          );
        }
      }
    } finally {
      controller.dispose();
    }
  }

  Widget _buildProfileIdentityHeader(String uid) {
    final authEmail = FirebaseAuth.instance.currentUser?.email?.trim() ?? '';

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('Users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
              ],
            ),
            child: Text(
              'Could not load profile. ${snapshot.error}',
              style: TextStyle(color: textMuted, fontSize: 14),
            ),
          );
        }

        final data = snapshot.data?.data();
        final rawName = data?['name'];
        final nameFromDoc = rawName is String ? rawName.trim() : '';
        final docEmail = data?['email'];
        final emailStr = (docEmail is String && docEmail.trim().isNotEmpty)
            ? docEmail.trim()
            : (authEmail.isNotEmpty ? authEmail : 'No email on file');
        final hasName = nameFromDoc.isNotEmpty;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _pickProfileImage(uid),
                  borderRadius: BorderRadius.circular(999),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: navSelected.withValues(alpha: 0.15),
                        backgroundImage: _avatarBytes != null ? MemoryImage(_avatarBytes!) : null,
                        child: _avatarBytes == null
                            ? Icon(Icons.person_rounded, size: 40, color: navSelected)
                            : null,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: navSelected,
                            shape: BoxShape.circle,
                            border: Border.all(color: cardWhite, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasName)
                      Text(
                        nameFromDoc,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark, height: 1.2),
                      )
                    else
                      Text(
                        'No name yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textMuted, height: 1.2),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      emailStr,
                      style: TextStyle(fontSize: 14, color: textMuted, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _showEditNameDialog(uid, hasName ? nameFromDoc : null),
                      style: TextButton.styleFrom(
                        foregroundColor: navSelected,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(hasName ? Icons.edit_rounded : Icons.person_add_alt_1_rounded, size: 18),
                      label: Text(hasName ? 'Edit name' : 'Add your name', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<double> _getMoodData() {
    switch (_selectedRange) {
      case _TimeRange.day:
        return [0.4, 0.5, 0.7, 0.6, 0.8, 0.75, 0.9, 0.85];
      case _TimeRange.week:
        return [0.5, 0.6, 0.45, 0.7, 0.65, 0.8, 0.75];
      case _TimeRange.month:
        return [0.55, 0.62, 0.58, 0.7, 0.68];
      case _TimeRange.year:
        return [0.5, 0.55, 0.6, 0.58, 0.65, 0.7, 0.72, 0.68, 0.75, 0.78, 0.8, 0.82];
    }
  }

  List<String> _getXLabels() {
    switch (_selectedRange) {
      case _TimeRange.day:
        return ['6am', '9am', '12pm', '3pm', '6pm', '9pm', '10pm', '11pm'];
      case _TimeRange.week:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case _TimeRange.month:
        return ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4', 'Wk 5'];
      case _TimeRange.year:
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
  }

  Future<void> _confirmAndLogOut() async {
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log out?', style: TextStyle(color: textDark, fontWeight: FontWeight.bold)),
        content: Text(
          'You will need to sign in again to use the app.',
          style: TextStyle(color: textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: navSelected),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (shouldLogOut != true || !mounted) return;
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings_rounded, color: textDark),
            color: cardWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            offset: const Offset(0, kToolbarHeight - 8),
            onSelected: (value) {
              if (value == 'logout') _confirmAndLogOut();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: textDark, size: 22),
                    const SizedBox(width: 12),
                    Text('Log out', style: TextStyle(color: textDark, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubtitle(),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Sign in to see your account details.',
                        style: TextStyle(fontSize: 14, color: textMuted),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileIdentityHeader(user.uid),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
              _buildSummaryCard(),
              const SizedBox(height: 24),
              _buildTimeRangeSelector(),
              const SizedBox(height: 20),
              _buildMoodGraphCard(),
              const SizedBox(height: 24),
              _buildLegendCard(),
              const SizedBox(height: 16),
              _buildLogOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Your mood and emotion over time.',
      style: TextStyle(fontSize: 16, color: textMuted, height: 1.4),
    );
  }

  Widget _buildLogOutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _confirmAndLogOut,
        icon: Icon(Icons.logout_rounded, color: navSelected),
        label: Text(
          'Log out',
          style: TextStyle(color: navSelected, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: navSelected.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navSelected.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.emoji_emotions_rounded, color: navSelected, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Average mood', style: TextStyle(fontSize: 14, color: textMuted)),
                const SizedBox(height: 4),
                Text('Good', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRangeChip('Day', _TimeRange.day),
          const SizedBox(width: 10),
          _buildRangeChip('Week', _TimeRange.week),
          const SizedBox(width: 10),
          _buildRangeChip('Month', _TimeRange.month),
          const SizedBox(width: 10),
          _buildRangeChip('Year', _TimeRange.year),
        ],
      ),
    );
  }

  Widget _buildRangeChip(String label, _TimeRange range) {
    final isSelected = _selectedRange == range;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedRange = range),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? navSelected : cardWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? navSelected : textMuted.withValues(alpha: 0.3), width: 1.5),
            boxShadow: isSelected
                ? [BoxShadow(color: navSelected.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodGraphCard() {
    final data = _getMoodData();
    final labels = _getXLabels();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart_rounded, color: tipCardPurple, size: 22),
              const SizedBox(width: 8),
              Text('Mood & emotion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: _MoodLineChartPainter(
                data: data,
                lineColor: navSelected,
                fillColor: navSelected.withValues(alpha: 0.15),
                gridColor: textMuted.withValues(alpha: 0.12),
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: labels.asMap().entries.map((e) {
                return Padding(
                  padding: EdgeInsets.only(right: e.key < labels.length - 1 ? (data.length <= 7 ? 24 : 12) : 0),
                  child: SizedBox(
                    width: data.length <= 7 ? 36 : 28,
                    child: Text(
                      e.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: textMuted.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Y-axis: higher = good / low stress; lower = high stress / bad. Tap Day, Week, Month, or Year to change the range.',
              style: TextStyle(fontSize: 13, color: textMuted, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodLineChartPainter extends CustomPainter {
  _MoodLineChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final w = size.width;
    final h = size.height;
    const chartLeft = 4.0;
    final chartRight = w - 4;
    const chartTop = 8.0;
    final chartBottom = h - 8;
    final chartW = chartRight - chartLeft;
    final chartH = chartBottom - chartTop;
    final stepX = data.length > 1 ? chartW / (data.length - 1) : chartW;

    final gridPaint = Paint()..color = gridColor..strokeWidth = 1;
    for (int i = 1; i <= 4; i++) {
      final y = chartTop + chartH * (i / 5);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
    }

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = chartLeft + i * stepX;
      final y = chartBottom - data[i] * chartH;
      points.add(Offset(x, y));
    }

    if (points.length >= 2) {
      final fillPath = Path()..moveTo(points.first.dx, chartBottom);
      for (final p in points) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(points.last.dx, chartBottom);
      fillPath.close();
      canvas.drawPath(fillPath, Paint()..color = fillColor..style = PaintingStyle.fill);
    }

    if (points.length >= 2) {
      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(
        linePath,
        Paint()
          ..color = lineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    final dotPaint = Paint()..color = lineColor..style = PaintingStyle.fill;
    final borderPaint = Paint()..color = cardWhite..style = PaintingStyle.stroke..strokeWidth = 2;
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 4, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodLineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.lineColor != lineColor || oldDelegate.fillColor != fillColor;
  }
}

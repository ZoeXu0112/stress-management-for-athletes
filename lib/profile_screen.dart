import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Profile screen with mood/emotion graph — UI only.
enum _TimeRange { day, week, month, year }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _TimeRange _selectedRange = _TimeRange.week;

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
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildTimeRangeSelector(),
            const SizedBox(height: 20),
            _buildMoodGraphCard(),
            const SizedBox(height: 24),
            _buildLegendCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark)),
        const SizedBox(height: 6),
        Text('Your mood and emotion over time.', style: TextStyle(fontSize: 16, color: textMuted)),
      ],
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
    return Row(
      children: [
        _buildRangeChip('Day', _TimeRange.day),
        const SizedBox(width: 10),
        _buildRangeChip('Week', _TimeRange.week),
        const SizedBox(width: 10),
        _buildRangeChip('Month', _TimeRange.month),
        const SizedBox(width: 10),
        _buildRangeChip('Year', _TimeRange.year),
      ],
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4, bottom: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Good', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusGood)),
                    Text('High stress', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textMuted)),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 180,
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
              ),
            ],
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
      for (final p in points) fillPath.lineTo(p.dx, p.dy);
      fillPath.lineTo(points.last.dx, chartBottom);
      fillPath.close();
      canvas.drawPath(fillPath, Paint()..color = fillColor..style = PaintingStyle.fill);
    }

    if (points.length >= 2) {
      final linePath = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) linePath.lineTo(points[i].dx, points[i].dy);
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

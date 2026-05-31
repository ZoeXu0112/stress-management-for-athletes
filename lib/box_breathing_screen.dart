import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stress_management_by_zoe/constants.dart';

/// Guided box breathing using [assetPath]. Visuals follow a repeating
/// inhale → hold → exhale → hold cycle. If they drift from the voice,
/// adjust [_kPhaseStartDelay] (skip intro talk) or [_kSecondsPerPhase].
class BoxBreathingScreen extends StatefulWidget {
  const BoxBreathingScreen({super.key});

  static const assetPath = 'assets/box_breathing_guided.mp3';

  @override
  State<BoxBreathingScreen> createState() => _BoxBreathingScreenState();
}

/// When the first inhale cue begins, set this so phase 0 aligns (e.g. 30–60s for intros).
const Duration _kPhaseStartDelay = Duration.zero;

/// Seconds per side of the box (inhale / hold / exhale / hold). Beginner guides are often ~4–6s.
const int _kSecondsPerPhase = 5;

enum _BoxPhase { inhale, holdFull, exhale, holdEmpty }

class _BoxBreathingScreenState extends State<BoxBreathingScreen> {
  late final AudioPlayer _player = AudioPlayer();
  bool _loading = true;
  String? _loadError;
  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setAsset(BoxBreathingScreen.assetPath);
      _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _player.durationStream.listen((d) {
        if (mounted) setState(() => _duration = d);
      });
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
    setState(() {});
  }

  ({_BoxPhase phase, double phaseProgress, bool beforeStart}) _phaseAt(Duration position) {
    final adjusted = position - _kPhaseStartDelay;
    if (adjusted.isNegative) {
      return (phase: _BoxPhase.inhale, phaseProgress: 0, beforeStart: true);
    }
    final cycleMs = _kSecondsPerPhase * 4 * 1000;
    final ms = adjusted.inMilliseconds % cycleMs;
    final phaseLenMs = _kSecondsPerPhase * 1000;
    final idx = ms ~/ phaseLenMs;
    final phaseProgress = (ms % phaseLenMs) / phaseLenMs;
    final phase = switch (idx) {
      0 => _BoxPhase.inhale,
      1 => _BoxPhase.holdFull,
      2 => _BoxPhase.exhale,
      _ => _BoxPhase.holdEmpty,
    };
    return (phase: phase, phaseProgress: phaseProgress.clamp(0.0, 1.0), beforeStart: false);
  }

  double _orbScale(_BoxPhase phase, double phaseProgress, bool beforeStart) {
    const minS = 0.72;
    const maxS = 1.12;
    if (beforeStart) return minS;
    final t = Curves.easeInOut.transform(phaseProgress);
    return switch (phase) {
      _BoxPhase.inhale => minS + t * (maxS - minS),
      _BoxPhase.holdFull => maxS,
      _BoxPhase.exhale => maxS - t * (maxS - minS),
      _BoxPhase.holdEmpty => minS,
    };
  }

  String _phaseTitle(_BoxPhase phase, bool beforeStart) {
    if (beforeStart) return 'Get ready';
    return switch (phase) {
      _BoxPhase.inhale => 'Inhale',
      _BoxPhase.holdFull => 'Hold',
      _BoxPhase.exhale => 'Exhale',
      _BoxPhase.holdEmpty => 'Hold',
    };
  }

  String _phaseHint(_BoxPhase phase, bool beforeStart) {
    if (beforeStart) return 'Press play and follow the guide';
    return switch (phase) {
      _BoxPhase.inhale => 'Fill the lungs slowly',
      _BoxPhase.holdFull => 'Keep the breath gently',
      _BoxPhase.exhale => 'Release fully and softly',
      _BoxPhase.holdEmpty => 'Rest here before the next breath',
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = _phaseAt(_position);
    final scale = _orbScale(state.phase, state.phaseProgress, state.beforeStart);
    final playing = _player.playing;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textDark,
        title: const Text('Box Breathing'),
        actions: [
          if (!_loading && _loadError == null)
            IconButton(
              icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
              onPressed: _togglePlay,
            ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: navSelected))
            : _loadError != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Could not load audio.\n$_loadError',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textMuted, fontSize: 16),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: _buildProgressRow(),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: CustomPaint(
                                  painter: _PhaseIllustrationPainter(
                                    phase: state.phase,
                                    progress: state.phaseProgress,
                                    beforeStart: state.beforeStart,
                                  ),
                                  size: Size.infinite,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _phaseTitle(state.phase, state.beforeStart),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _phaseHint(state.phase, state.beforeStart),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: textMuted, height: 1.35),
                              ),
                              const SizedBox(height: 32),
                              Expanded(
                                child: Center(
                                  child: _BreathingOrb(scale: scale, phase: state.phase, beforeStart: state.beforeStart),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FilledButton.tonalIcon(
                                    onPressed: () async {
                                      await _player.seek(Duration.zero);
                                      await _player.play();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.replay_rounded),
                                    label: const Text('From start'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildProgressRow() {
    final total = _duration ?? Duration.zero;
    final secs = total.inSeconds > 0 ? total.inSeconds : 1;
    final progress = _position.inMilliseconds / (total.inMilliseconds > 0 ? total.inMilliseconds : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: progress.clamp(0.0, 1.0),
          onChanged: (v) async {
            final ms = (v * total.inMilliseconds).round();
            await _player.seek(Duration(milliseconds: ms));
            setState(() {});
          },
          activeColor: navSelected,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_fmt(_position), style: TextStyle(fontSize: 13, color: textMuted)),
            Text(_fmt(total), style: TextStyle(fontSize: 13, color: textMuted)),
          ],
        ),
        Text(
          '~$secs min guided audio',
          style: TextStyle(fontSize: 12, color: textMuted.withValues(alpha: 0.85)),
        ),
      ],
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _BreathingOrb extends StatelessWidget {
  const _BreathingOrb({
    required this.scale,
    required this.phase,
    required this.beforeStart,
  });

  final double scale;
  final _BoxPhase phase;
  final bool beforeStart;

  @override
  Widget build(BuildContext context) {
    final colors = beforeStart
        ? [tipCardPurple.withValues(alpha: 0.35), navSelected.withValues(alpha: 0.25)]
        : switch (phase) {
            _BoxPhase.inhale => [const Color(0xFF63B3ED), navSelected.withValues(alpha: 0.9)],
            _BoxPhase.holdFull => [navSelected, const Color(0xFF2B6CB0)],
            _BoxPhase.exhale => [const Color(0xFFB794F4), tipCardPurple.withValues(alpha: 0.85)],
            _BoxPhase.holdEmpty => [textMuted.withValues(alpha: 0.45), textMuted.withValues(alpha: 0.25)],
          };

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors,
            stops: const [0.2, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: colors[1].withValues(alpha: 0.45),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft “image-like” motifs that change with each phase (inhale / hold / exhale).
class _PhaseIllustrationPainter extends CustomPainter {
  _PhaseIllustrationPainter({
    required this.phase,
    required this.progress,
    required this.beforeStart,
  });

  final _BoxPhase phase;
  final double progress;
  final bool beforeStart;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    if (beforeStart) {
      _drawIntro(canvas, size, center);
      return;
    }
    switch (phase) {
      case _BoxPhase.inhale:
        _drawInhale(canvas, size, center, progress);
        break;
      case _BoxPhase.holdFull:
        _drawHoldFull(canvas, size, center, progress);
        break;
      case _BoxPhase.exhale:
        _drawExhale(canvas, size, center, progress);
        break;
      case _BoxPhase.holdEmpty:
        _drawHoldEmpty(canvas, size, center, progress);
        break;
    }
  }

  void _drawIntro(Canvas canvas, Size size, Offset c) {
    final p = Paint()
      ..shader = RadialGradient(
        colors: [navSelected.withValues(alpha: 0.2), Colors.transparent],
      ).createShader(Rect.fromCircle(center: c, radius: size.shortestSide * 0.45));
    canvas.drawCircle(c, size.shortestSide * 0.4, p);
  }

  void _drawInhale(Canvas canvas, Size size, Offset c, double t) {
    final breathe = Curves.easeOut.transform(t);
    final expand = 1.0 + breathe * 0.35;
    for (var i = 0; i < 5; i++) {
      final y = c.dy + 40 - i * 28 * expand;
      final w = (50 + i * 18) * expand;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = navSelected.withValues(alpha: 0.15 + i * 0.12);
      canvas.drawArc(
        Rect.fromCenter(center: Offset(c.dx, y), width: w, height: w * 0.45),
        math.pi * 1.15,
        math.pi * 0.7,
        false,
        paint,
      );
    }
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF63B3ED).withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: 90 * expand));
    canvas.drawCircle(c, 80 * expand, glow);
  }

  void _drawHoldFull(Canvas canvas, Size size, Offset c, double t) {
    final pulse = 1.0 + math.sin(t * math.pi * 2) * 0.04;
    for (var r = 1; r <= 3; r++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = navSelected.withValues(alpha: 0.45 - r * 0.1);
      canvas.drawCircle(c, (50.0 + r * 28) * pulse, paint);
    }
  }

  void _drawExhale(Canvas canvas, Size size, Offset c, double t) {
    final release = Curves.easeIn.transform(t);
    final fall = release * 60;
    for (var i = 0; i < 6; i++) {
      final spread = (i - 2.5) * 22;
      final y = c.dy - 30 + fall + i * 6;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = tipCardPurple.withValues(alpha: 0.5 - i * 0.06);
      final path = Path()
        ..moveTo(c.dx - 80 + spread, y)
        ..quadraticBezierTo(c.dx + spread, y + 24, c.dx + 80 + spread, y + 8);
      canvas.drawPath(path, paint);
    }
    final mist = Paint()
      ..shader = RadialGradient(
        colors: [
          tipCardPurple.withValues(alpha: 0.22 * (1 - release)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(c.dx, c.dy + 20), radius: 100));
    canvas.drawCircle(Offset(c.dx, c.dy + 20), 90 * (1 - release * 0.4), mist);
  }

  void _drawHoldEmpty(Canvas canvas, Size size, Offset c, double t) {
    final calm = Paint()
      ..color = textMuted.withValues(alpha: 0.25 + t * 0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = -2; i <= 2; i++) {
      final y = c.dy + i * 14.0;
      canvas.drawLine(Offset(c.dx - 70, y), Offset(c.dx + 70, y), calm);
    }
  }

  @override
  bool shouldRepaint(covariant _PhaseIllustrationPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.progress != progress ||
        oldDelegate.beforeStart != beforeStart;
  }
}

import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/constants.dart';
import 'package:video_player/video_player.dart';

/// Full-screen local asset playback for the recommended breathing exercise.
class BreathingExerciseVideoScreen extends StatefulWidget {
  const BreathingExerciseVideoScreen({super.key});

  static const assetPath = 'assets/breathing_video.mp4';

  @override
  State<BreathingExerciseVideoScreen> createState() => _BreathingExerciseVideoScreenState();
}

class _BreathingExerciseVideoScreenState extends State<BreathingExerciseVideoScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeOnly;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      BreathingExerciseVideoScreen.assetPath,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    // Do not chain `play()` into this future: FutureBuilder would stay on the loading
    // branch until `play()` completes, so VideoPlayer never mounts and the texture
    // is not attached when playback starts.
    _initializeOnly = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _aspectRatio() {
    final r = _controller.value.aspectRatio;
    return r > 0 ? r : 16 / 9;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Pre-Performance Breathing'),
        actions: [
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (!value.isInitialized) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                onPressed: () {
                  if (value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeOnly,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not play this video.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 16),
                ),
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator(color: navSelected));
          }
          if (!_controller.value.isInitialized) {
            return Center(
              child: Text(
                'Could not play this video.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 16),
              ),
            );
          }

          return _AutoPlayVideoView(
            controller: _controller,
            aspectRatio: _aspectRatio(),
          );
        },
      ),
    );
  }
}

/// Calls [VideoPlayerController.play] after this widget is in the tree so the
/// platform video surface exists before playback starts.
class _AutoPlayVideoView extends StatefulWidget {
  const _AutoPlayVideoView({
    required this.controller,
    required this.aspectRatio,
  });

  final VideoPlayerController controller;
  final double aspectRatio;

  @override
  State<_AutoPlayVideoView> createState() => _AutoPlayVideoViewState();
}

class _AutoPlayVideoViewState extends State<_AutoPlayVideoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: VideoPlayer(widget.controller),
      ),
    );
  }
}

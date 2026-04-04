import 'package:flutter/material.dart';
import 'package:stress_management_by_zoe/auth_wrapper.dart';

/// Path to splash image in [assets].
const String kSplashImageAsset = 'assets/0540317C-3BB3-4403-9E97-4393FABF3CB9.png';

/// Shows the splash image for [kSplashDuration], then [AuthWrapper] (login vs home).
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  static const Duration kSplashDuration = Duration(seconds: 3);

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(SplashGate.kSplashDuration, () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  kSplashImageAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Splash image not found.\nAdd it under assets/ and run flutter pub get.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const AuthWrapper();
  }
}

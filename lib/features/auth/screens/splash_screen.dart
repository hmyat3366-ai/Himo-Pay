import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../widgets/pixel_assembly_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateNext();
      }
    });
  }

  void _navigateNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed('/login-phone');
  }

  void _replay() {
    setState(() {
      _navigated = false;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E15), // Deep midnight navy-black matching video
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateNext,
        child: Stack(
          children: [
            // Subtle ambient background gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.05),
                    radius: 0.85,
                    colors: [
                      Color(0x18FF5E14),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ),

            // Center Logo with Pixel Assembly Animation
            Center(
              child: PixelAssemblyLogo(
                controller: _controller,
                onComplete: _navigateNext,
              ),
            ),

            // Top Bar with subtle replay & skip controls
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Replay button (discreet, for testing / user review)
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.gray500, size: 20),
                      tooltip: 'Replay Animation',
                      onPressed: _replay,
                    ),
                    // Skip button
                    TextButton(
                      onPressed: _navigateNext,
                      child: Text(
                        'Skip'.tr('ကျော်မည်'),
                        style: TextStyle(
                          color: AppColors.gray400.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom subtle loading / progress bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _controller.value,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF5E14)),
                    minHeight: 2.5,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

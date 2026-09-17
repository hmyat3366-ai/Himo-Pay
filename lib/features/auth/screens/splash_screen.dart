import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/storage/app_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
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
    final nextRoute = AppPreferences.isLoggedIn ? '/main' : '/login-phone';
    Navigator.of(context).pushReplacementNamed(nextRoute);
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
      backgroundColor: const Color(0xFF0D1117), // Matches native launch screen background
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateNext,
        child: Stack(
          children: [
            // 1. Subtle Ambient Radial Glow
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.1),
                        radius: 0.9,
                        colors: [
                          const Color(0xFFFF5E14).withValues(alpha: 0.14 * _glowAnimation.value),
                          const Color(0x00000000),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. Centered Logo & Brand Wordmark
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App Icon Mark with soft shadow
                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5E14),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5E14).withValues(alpha: 0.35 * _glowAnimation.value),
                                  blurRadius: 28,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/images/himo_logo_white.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Brand Wordmark
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'HIMO',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3.5,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'PAY',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3.5,
                                  color: const Color(0xFFFF5E14),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Subtitle Tagline
                          Text(
                            'FAST · SECURE · MODERN PAYMENTS',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.2,
                              color: AppColors.gray400.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 3. Top Skip Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.gray500, size: 20),
                      tooltip: 'Replay Animation',
                      onPressed: _replay,
                    ),
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

            // 4. Sleek Bottom Progress Bar
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

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_logo.dart';

/// Represents a discrete digital pixel block that participates in the
/// assembly animation inspired by the Eventekki motion design.
class _PixelCell {
  final double targetX;
  final double targetY;
  final double width;
  final double height;
  final Color color;
  final double stagger; // 0.0 to 1.0 (determines relative launch time)
  final bool isCornerAccent;

  const _PixelCell({
    required this.targetX,
    required this.targetY,
    required this.width,
    required this.height,
    required this.color,
    this.stagger = 0.0,
    this.isCornerAccent = false,
  });
}

/// PixelAssemblyLogo
/// Recreates the cyber-pixel logo reveal animation:
/// 1. Genesis: 2 center diagonal pixel blocks (Orange & Cyber White).
/// 2. Diagonal Step: Snappy position swap / pulse.
/// 3. Horizontal Scatter: Pixel blocks multiply and shoot outwards across the grid.
/// 4. Morph & Coalesce: Pixel bars stretch vertically and fuse into the HimoPay mark & wordmark.
/// 5. Corner Accents: Stepped square pixels remain docked at top-left and top-right.
/// 6. Radiance & Subtitle: Subtle neon glow bloom and subtitle reveal.
class PixelAssemblyLogo extends StatefulWidget {
  final AnimationController controller;
  final VoidCallback? onComplete;

  const PixelAssemblyLogo({
    super.key,
    required this.controller,
    this.onComplete,
  });

  @override
  State<PixelAssemblyLogo> createState() => _PixelAssemblyLogoState();
}

class _PixelAssemblyLogoState extends State<PixelAssemblyLogo> {
  // Collection of pixel cells that map to the HimoPay logo geometry
  late final List<_PixelCell> _cells;

  @override
  void initState() {
    super.initState();
    _initPixelCells();
  }

  void _initPixelCells() {
    const orange = Color(0xFFFF5E14);
    const white = Color(0xFFF3F5EB); // cyber off-white matching reference video

    _cells = [
      // ── Himo Icon Left Pillar (Orange) ──
      const _PixelCell(targetX: -112, targetY: -22, width: 14, height: 22, color: orange, stagger: 0.10),
      const _PixelCell(targetX: -112, targetY: 0, width: 14, height: 22, color: orange, stagger: 0.15),
      // Left Pillar Crossbar
      const _PixelCell(targetX: -98, targetY: -7, width: 14, height: 14, color: orange, stagger: 0.20),

      // ── Himo Icon Right Pillar (White) ──
      const _PixelCell(targetX: -84, targetY: -22, width: 14, height: 20, color: white, stagger: 0.22),
      const _PixelCell(targetX: -84, targetY: 2, width: 14, height: 20, color: white, stagger: 0.26),
      // Semicircle tab
      const _PixelCell(targetX: -70, targetY: -7, width: 10, height: 14, color: white, stagger: 0.28),

      // ── Wordmark Letters (White) ──
      // 'H'
      const _PixelCell(targetX: -44, targetY: -18, width: 8, height: 36, color: white, stagger: 0.32),
      const _PixelCell(targetX: -26, targetY: -18, width: 8, height: 36, color: white, stagger: 0.36),
      const _PixelCell(targetX: -36, targetY: -3, width: 10, height: 6, color: white, stagger: 0.38),

      // 'i'
      const _PixelCell(targetX: -12, targetY: -7, width: 7, height: 25, color: white, stagger: 0.42),
      const _PixelCell(targetX: -12, targetY: -18, width: 7, height: 7, color: white, stagger: 0.44),

      // 'm'
      const _PixelCell(targetX: 2, targetY: -7, width: 7, height: 25, color: white, stagger: 0.48),
      const _PixelCell(targetX: 15, targetY: -7, width: 7, height: 25, color: white, stagger: 0.52),
      const _PixelCell(targetX: 28, targetY: -7, width: 7, height: 25, color: white, stagger: 0.56),

      // 'o'
      const _PixelCell(targetX: 42, targetY: -7, width: 18, height: 25, color: white, stagger: 0.60),

      // 'P'
      const _PixelCell(targetX: 68, targetY: -18, width: 8, height: 36, color: white, stagger: 0.64),
      const _PixelCell(targetX: 76, targetY: -18, width: 14, height: 20, color: white, stagger: 0.68),

      // 'a'
      const _PixelCell(targetX: 96, targetY: -7, width: 16, height: 25, color: white, stagger: 0.72),

      // 'y'
      const _PixelCell(targetX: 118, targetY: -7, width: 16, height: 32, color: white, stagger: 0.76),

      // ── Signature Stepped Corner Accent Pixels (From Video Reference) ──
      // Top-Left stepped pixels (Orange)
      const _PixelCell(targetX: -122, targetY: -28, width: 10, height: 10, color: orange, stagger: 0.12, isCornerAccent: true),
      const _PixelCell(targetX: -134, targetY: -40, width: 10, height: 10, color: orange, stagger: 0.08, isCornerAccent: true),

      // Top-Right stepped pixel (White)
      const _PixelCell(targetX: 126, targetY: -28, width: 10, height: 10, color: white, stagger: 0.80, isCornerAccent: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final progress = widget.controller.value;

        // Subtitle animation (fades in during phase 4: 0.78 to 1.0)
        final subtitleOpacity = ((progress - 0.76) / 0.18).clamp(0.0, 1.0);
        final subtitleSlide = (1.0 - subtitleOpacity) * 12.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Center Logo Canvas with Pixel Assembly
            SizedBox(
              width: 320,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient Neon Glow behind the logo
                  if (progress > 0.4)
                    Opacity(
                      opacity: ((progress - 0.4) / 0.4).clamp(0.0, 0.55),
                      child: Container(
                        width: 220,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF5E14).withValues(alpha: 0.4),
                              blurRadius: 50,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Assembled Vector Logo (fades in seamlessly as pixels coalesce)
                  if (progress > 0.55)
                    Opacity(
                      opacity: ((progress - 0.55) / 0.25).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 0.96 + 0.04 * ((progress - 0.55) / 0.45).clamp(0.0, 1.0),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            HimoPayIcon(
                              size: 46,
                              orangeColor: Color(0xFFFF5E14),
                              rightPillarColor: Color(0xFFF3F5EB),
                            ),
                            SizedBox(width: 14),
                            Text(
                              'HimoPay',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFF3F5EB),
                                letterSpacing: -0.8,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Custom Painter that renders:
                  // 1. Genesis diagonal squares
                  // 2. Horizontal scattering pixels
                  // 3. Morphing pixel bars
                  // 4. Corner accent pixel blocks
                  CustomPaint(
                    size: const Size(320, 140),
                    painter: _PixelRevealPainter(
                      progress: progress,
                      cells: _cells,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Tagline reveal with tracking and high-tech indicator
            Opacity(
              opacity: subtitleOpacity,
              child: Transform.translate(
                offset: Offset(0, subtitleSlide),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5E14),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SMART DIGITAL LIFESTYLE WALLET',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.4,
                            color: AppColors.gray400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5E14),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PixelRevealPainter extends CustomPainter {
  final double progress;
  final List<_PixelCell> cells;

  _PixelRevealPainter({
    required this.progress,
    required this.cells,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    const orange = Color(0xFFFF5E14);
    const white = Color(0xFFF3F5EB);

    // ─────────────────────────────────────────────────────────────
    // STAGE 1: GENESIS (0.00 -> 0.24)
    // 2 diagonal square pixel blocks in center
    // ─────────────────────────────────────────────────────────────
    if (progress < 0.32) {
      final genesisScale = (progress / 0.12).clamp(0.0, 1.0);
      final curvedScale = Curves.easeOutBack.transform(genesisScale);

      const double blockSize = 16.0;

      // Diagonal step flip at 0.14 -> 0.22
      double stepT = ((progress - 0.14) / 0.08).clamp(0.0, 1.0);
      stepT = Curves.easeInOutCubic.transform(stepT);

      // Block 1 (Orange): starts bottom-left (-half, +half), steps to top-left (-half, -half)
      final double b1X = -blockSize / 2;
      final double b1Y = (blockSize / 2) * (1 - 2 * stepT);

      // Block 2 (White): starts top-right (+half, -half), steps to bottom-right (+half, +half)
      final double b2X = blockSize / 2;
      final double b2Y = (-blockSize / 2) * (1 - 2 * stepT);

      final paintOrange = Paint()..color = orange;
      final paintWhite = Paint()..color = white;

      // Draw Block 1
      final r1 = Rect.fromCenter(
        center: center + Offset(b1X, b1Y),
        width: blockSize * curvedScale,
        height: blockSize * curvedScale,
      );
      canvas.drawRect(r1, paintOrange);

      // Draw Block 2
      final r2 = Rect.fromCenter(
        center: center + Offset(b2X, b2Y),
        width: blockSize * curvedScale,
        height: blockSize * curvedScale,
      );
      canvas.drawRect(r2, paintWhite);
      return;
    }

    // ─────────────────────────────────────────────────────────────
    // STAGE 2 & 3: HORIZONTAL SCATTER & MORPHING (0.24 -> 0.85)
    // ─────────────────────────────────────────────────────────────
    // As progress goes from 0.24 to 0.70, pixels shoot out horizontally
    // As progress goes from 0.60 to 0.82, pixel blocks dissolve into vector logo
    // Stepped corner accents remain visible after 0.75!
    final scatterT = ((progress - 0.24) / 0.36).clamp(0.0, 1.0);
    final dissolveT = ((progress - 0.62) / 0.18).clamp(0.0, 1.0);

    for (final cell in cells) {
      // If regular pixel cell and fully dissolved, skip drawing to let vector logo shine
      if (!cell.isCornerAccent && dissolveT >= 1.0) {
        continue;
      }

      // Individual staggered launch
      final blockProgress = ((scatterT - cell.stagger * 0.4) / (1.0 - cell.stagger * 0.4)).clamp(0.0, 1.0);
      if (blockProgress <= 0.0) continue;

      final curvedFlight = Curves.easeOutExpo.transform(blockProgress);

      // Position interpolates from center (0, 0) horizontally outwards to (targetX, targetY)
      final currentX = center.dx + cell.targetX * curvedFlight;
      // Y stays close to center line during early flight, then expands to targetY
      final yFactor = Curves.easeOutBack.transform(((blockProgress - 0.3) / 0.7).clamp(0.0, 1.0));
      final currentY = center.dy + cell.targetY * yFactor;

      // Width and Height morph
      // In early flight, width and height are small crisp squares (10x10)
      final double w = math.max(6.0, 10.0 + (cell.width - 10.0) * yFactor);
      final double h = math.max(6.0, 10.0 + (cell.height - 10.0) * yFactor);

      // Opacity calculation
      double opacity = 1.0;
      if (!cell.isCornerAccent) {
        opacity = (1.0 - dissolveT).clamp(0.0, 1.0);
      } else {
        // Corner accents stay docked and give a subtle cyber breathing pulse at the end
        if (progress > 0.82) {
          final pulse = math.sin((progress - 0.82) * math.pi * 4);
          opacity = (0.85 + 0.15 * pulse).clamp(0.0, 1.0);
        }
      }

      if (opacity <= 0.01) continue;

      final paint = Paint()
        ..color = cell.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // Draw the pixel block
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(currentX, currentY),
          width: w,
          height: h,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PixelRevealPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

enum LogoVariant {
  auto,
  dark,
  light,
}

/// HimoPayIcon — 100% Native Vector Logo Icon (No SVG asset dependencies needed)
/// Renders the signature HimoPay "H" mark:
/// Left Orange pillar with horizontal arm + Right pillar with semicircle notch & tab.
class HimoPayIcon extends StatelessWidget {
  final double size;
  final Color? orangeColor;
  final Color? rightPillarColor;

  const HimoPayIcon({
    super.key,
    this.size = 40.0,
    this.orangeColor,
    this.rightPillarColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orange = orangeColor ?? AppColors.brandFor(isDark);
    final rightColor = rightPillarColor ?? (isDark ? Colors.white : AppColors.charcoalText);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HimoPayIconPainter(
          orangeColor: orange,
          rightPillarColor: rightColor,
        ),
      ),
    );
  }
}

class _HimoPayIconPainter extends CustomPainter {
  final Color orangeColor;
  final Color rightPillarColor;

  _HimoPayIconPainter({
    required this.orangeColor,
    required this.rightPillarColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate scale based on 100x100 design grid
    final double s = size.width / 100.0;

    final orangePaint = Paint()
      ..color = orangeColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rightPaint = Paint()
      ..color = rightPillarColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // ── 1. Left Orange Pillar + Horizontal Crossbar ──
    // Path: M10 10H30V40H49V60H30V90H10V10Z
    final orangePath = Path()
      ..moveTo(10 * s, 10 * s)
      ..lineTo(30 * s, 10 * s)
      ..lineTo(30 * s, 40 * s)
      ..lineTo(49 * s, 40 * s)
      ..lineTo(49 * s, 60 * s)
      ..lineTo(30 * s, 60 * s)
      ..lineTo(30 * s, 90 * s)
      ..lineTo(10 * s, 90 * s)
      ..close();

    canvas.drawPath(orangePath, orangePaint);

    // ── 2. Right Pillar with Semicircle Notch & Protruding Tab ──
    // Path: M49 10H69V40A10 10 0 0 1 69 60V90H49V60A10 10 0 0 1 49 40V10Z
    final rightPath = Path()
      ..moveTo(49 * s, 10 * s)
      ..lineTo(69 * s, 10 * s)
      ..lineTo(69 * s, 40 * s)
      // Right Semicircular Protruding Tab: from (69, 40) to (69, 60), bending outwards to x=79
      ..arcTo(
        Rect.fromCircle(center: Offset(69 * s, 50 * s), radius: 10 * s),
        -math.pi / 2, // -90 deg (top point)
        math.pi,      // 180 deg clockwise (sweep to bottom point)
        false,
      )
      ..lineTo(69 * s, 90 * s)
      ..lineTo(49 * s, 90 * s)
      ..lineTo(49 * s, 60 * s)
      // Left Semicircular Cutout Notch: from (49, 60) to (49, 40), curving into white pillar (to x=59)
      ..arcTo(
        Rect.fromCircle(center: Offset(49 * s, 50 * s), radius: 10 * s),
        math.pi / 2,  // 90 deg (bottom point)
        -math.pi,     // -180 deg counter-clockwise (sweep inwards to top point)
        false,
      )
      ..lineTo(49 * s, 10 * s)
      ..close();

    canvas.drawPath(rightPath, rightPaint);
  }

  @override
  bool shouldRepaint(covariant _HimoPayIconPainter oldDelegate) =>
      oldDelegate.orangeColor != orangeColor ||
      oldDelegate.rightPillarColor != rightPillarColor;
}

/// HimoPayLogo — Full Brand Logo (Icon Mark + HimoPay Wordmark)
/// Automatically theme-aware (Light mode: Charcoal text, Dark mode: White text).
class HimoPayLogo extends StatelessWidget {
  final double height;
  final LogoVariant variant;
  final bool showText;
  final Color? orangeColor;
  final Color? textColor;

  const HimoPayLogo({
    super.key,
    this.height = 40.0,
    this.variant = LogoVariant.auto,
    this.showText = true,
    this.orangeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final systemIsDark = Theme.of(context).brightness == Brightness.dark;
    final isDark = variant == LogoVariant.auto
        ? systemIsDark
        : (variant == LogoVariant.dark);

    final brandColor = orangeColor ?? AppColors.brandFor(isDark);
    final resolvedTextColor = textColor ??
        (isDark ? Colors.white : AppColors.charcoalText);

    final rightPillar = isDark ? Colors.white : AppColors.charcoalText;

    if (!showText) {
      return HimoPayIcon(
        size: height,
        orangeColor: brandColor,
        rightPillarColor: rightPillar,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HimoPayIcon(
          size: height,
          orangeColor: brandColor,
          rightPillarColor: rightPillar,
        ),
        SizedBox(width: height * 0.28),
        Text(
          'HimoPay',
          style: GoogleFonts.plusJakartaSans(
            fontSize: height * 0.74,
            fontWeight: FontWeight.w700,
            color: resolvedTextColor,
            letterSpacing: -0.8,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

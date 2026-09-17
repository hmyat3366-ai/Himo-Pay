import 'dart:math';
import 'package:flutter/material.dart';

/// HimoConfettiOverlay
/// Lightweight, zero-dependency celebratory confetti particle explosion
/// for payment success and reward screens.
class HimoConfettiOverlay extends StatefulWidget {
  final int particleCount;
  final Duration duration;

  const HimoConfettiOverlay({
    super.key,
    this.particleCount = 45,
    this.duration = const Duration(milliseconds: 3200),
  });

  @override
  State<HimoConfettiOverlay> createState() => _HimoConfettiOverlayState();
}

class _HimoConfettiOverlayState extends State<HimoConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiParticle> _particles;
  final Random _rnd = Random();

  final List<Color> _colors = const [
    Color(0xFFE5A93C), // Gold
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF97316), // Orange
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _particles = List.generate(widget.particleCount, (_) {
      return _ConfettiParticle(
        x: _rnd.nextDouble(),
        y: -0.1 - (_rnd.nextDouble() * 0.3),
        size: 7 + (_rnd.nextDouble() * 7),
        color: _colors[_rnd.nextInt(_colors.length)],
        speedY: 0.8 + (_rnd.nextDouble() * 0.9),
        speedX: (_rnd.nextDouble() - 0.5) * 0.6,
        rotation: _rnd.nextDouble() * 2 * pi,
        rotationSpeed: (_rnd.nextDouble() - 0.5) * 6,
        isCircle: _rnd.nextBool(),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = _controller.value;
          final opacity = (1.0 - (progress * progress)).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(_particles, progress),
            ),
          );
        },
      ),
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speedY;
  final double speedX;
  final double rotation;
  final double rotationSpeed;
  final bool isCircle;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final currentY = (p.y + (p.speedY * progress)) * size.height;
      final currentX = (p.x + (p.speedX * progress) + (sin(progress * 8 + p.rotation) * 0.05)) * size.width;
      final currentRot = p.rotation + (p.rotationSpeed * progress);

      if (currentY < -20 || currentY > size.height + 20) continue;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRot);

      final paint = Paint()..color = p.color;

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

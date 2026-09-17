import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// HimoShimmer — Pure Flutter Shimmer Animation (Zero third-party dependencies)
/// Provides realistic skeleton pulse loading effects for cards, balance, and list items.
class HimoShimmer extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const HimoShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<HimoShimmer> createState() => _HimoShimmerState();
}

class _HimoShimmerState extends State<HimoShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF21262D) : const Color(0xFFE5E9F0);
    final highlightColor = isDark ? const Color(0xFF30363D) : const Color(0xFFF6F8FA);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Shimmer Skeleton Placeholder Box
class HimoShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const HimoShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

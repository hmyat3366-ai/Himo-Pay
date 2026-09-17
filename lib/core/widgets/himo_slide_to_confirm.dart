import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// HimoSlideToConfirm
/// A modern, tactile "Slide to Pay / Confirm" swipe button
/// providing enhanced confirmation security and tactile haptic feedback.
class HimoSlideToConfirm extends StatefulWidget {
  final String label;
  final VoidCallback onConfirmed;
  final bool isProcessing;
  final Color? activeColor;

  const HimoSlideToConfirm({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.isProcessing = false,
    this.activeColor,
  });

  @override
  State<HimoSlideToConfirm> createState() => _HimoSlideToConfirmState();
}

class _HimoSlideToConfirmState extends State<HimoSlideToConfirm> {
  double _dragPosition = 0.0;
  bool _hasTriggered = false;

  static const double _handleSize = 48.0;
  static const double _height = 56.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.activeColor ?? AppColors.primaryGold;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - _handleSize - 8.0;

        return Container(
          height: _height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161B24) : const Color(0xFFEEF2F6),
            borderRadius: BorderRadius.circular(_height / 2),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Filled Progress Track Behind Handle
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: (_dragPosition + _handleSize + 4).clamp(0.0, constraints.maxWidth),
                height: _height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withValues(alpha: 0.25),
                      primaryColor.withValues(alpha: 0.55),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(_height / 2),
                ),
              ),

              // Center Hint Label
              Center(
                child: widget.isProcessing
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark ? AppColors.gray400 : AppColors.gray600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.keyboard_double_arrow_right_rounded,
                            size: 18,
                            color: primaryColor,
                          ),
                        ],
                      ),
              ),

              // Draggable Handle
              if (!widget.isProcessing)
                Positioned(
                  left: 4.0 + _dragPosition,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (_hasTriggered) return;
                      setState(() {
                        _dragPosition = (_dragPosition + details.delta.dx)
                            .clamp(0.0, maxDrag);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      if (_hasTriggered) return;
                      if (_dragPosition >= maxDrag * 0.82) {
                        // Complete Slide
                        setState(() {
                          _dragPosition = maxDrag;
                          _hasTriggered = true;
                        });
                        HapticFeedback.mediumImpact();
                        widget.onConfirmed();
                      } else {
                        // Snap back smoothly
                        setState(() {
                          _dragPosition = 0.0;
                        });
                      }
                    },
                    child: Container(
                      width: _handleSize,
                      height: _handleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor,
                            primaryColor.withValues(alpha: 0.85),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

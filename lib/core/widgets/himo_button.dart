import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

/// HimoButton — Theme-Aware Fintech Button
/// Primary: Brand Orange (#FF5E14 / #FF6B26), Crisp White Text
/// Secondary: Surface-adaptive (White in Light, Charcoal in Dark) with subtle border
class HimoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Widget? icon;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const HimoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
    this.height = 50.0,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = backgroundColor ??
        (isPrimary
            ? AppColors.brandFor(isDark)
            : (isDark ? AppColors.surfaceCardDark : Colors.white));
            
    final fg = textColor ??
        (isPrimary
            ? Colors.white
            : (isDark ? AppColors.textPrimaryDark : AppColors.charcoalText));

    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: isDark ? const Color(0xFF1C2128) : const Color(0xFFEAEFF5),
          disabledForegroundColor: isDark ? const Color(0xFF576071) : const Color(0xFF9AA5B6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.cardBorder,
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1.2,
                  ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppColors.brandFor(isDark),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isEnabled ? fg : (isDark ? const Color(0xFF576071) : const Color(0xFF9AA5B6)),
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

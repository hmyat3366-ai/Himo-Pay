import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../storage/app_preferences.dart';

/// HimoAmountKeypad — Dedicated Fintech On-Screen Number Keypad
/// Tailored for currency amount entry with digits 0-9, '00', backspace, and tactile haptics.
class HimoAmountKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback? onClear;
  final String leftActionText;
  final VoidCallback? onLeftAction;

  const HimoAmountKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    this.onClear,
    this.leftActionText = '00',
    this.onLeftAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3'], isDark),
        const SizedBox(height: 10),
        _buildRow(['4', '5', '6'], isDark),
        const SizedBox(height: 10),
        _buildRow(['7', '8', '9'], isDark),
        const SizedBox(height: 10),
        _buildBottomRow(isDark),
      ],
    );
  }

  Widget _buildRow(List<String> keys, bool isDark) {
    return Row(
      children: keys.map((k) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _buildButton(
            child: Text(
              k,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
            onTap: () {
              AppPreferences.triggerHaptic(HapticType.light);
              onKeyPress(k);
            },
            isDark: isDark,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildBottomRow(bool isDark) {
    return Row(
      children: [
        // Left Action ('00' or '.')
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildButton(
              child: Text(
                leftActionText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : AppColors.gray700,
                ),
              ),
              onTap: () {
                AppPreferences.triggerHaptic(HapticType.light);
                if (onLeftAction != null) {
                  onLeftAction!();
                } else {
                  onKeyPress(leftActionText);
                }
              },
              isDark: isDark,
            ),
          ),
        ),
        // '0'
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildButton(
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.gray900,
                ),
              ),
              onTap: () {
                AppPreferences.triggerHaptic(HapticType.light);
                onKeyPress('0');
              },
              isDark: isDark,
            ),
          ),
        ),
        // Backspace / Delete
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildButton(
              child: Icon(
                Icons.backspace_outlined,
                size: 22,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
              onTap: () {
                AppPreferences.triggerHaptic(HapticType.medium);
                onDelete();
              },
              onLongPress: () {
                AppPreferences.triggerHaptic(HapticType.heavy);
                if (onClear != null) {
                  onClear!();
                } else {
                  onDelete();
                }
              },
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColors.primary.withOpacity(0.12),
        highlightColor: AppColors.primary.withOpacity(0.08),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

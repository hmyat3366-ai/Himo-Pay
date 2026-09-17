import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../storage/app_preferences.dart';

class HimoKeypad extends StatelessWidget {
  final int pinLength;
  final int maxPinLength;
  final ValueChanged<int> onDigitPress;
  final VoidCallback onDeletePress;
  final VoidCallback? onBiometricPress;
  final bool showBiometric;

  const HimoKeypad({
    super.key,
    required this.pinLength,
    this.maxPinLength = 6,
    required this.onDigitPress,
    required this.onDeletePress,
    this.onBiometricPress,
    this.showBiometric = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxPinLength, (index) {
            final isFilled = index < pinLength;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isFilled
                      ? AppColors.primary
                      : (isDark ? AppColors.gray500 : AppColors.gray300),
                  width: 2,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 36),

        // Keypad Grid
        _buildKeypadRow(['1', '2', '3'], ['', 'ABC', 'DEF'], isDark),
        const SizedBox(height: 16),
        _buildKeypadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO'], isDark),
        const SizedBox(height: 16),
        _buildKeypadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ'], isDark),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Biometric or empty
            showBiometric
                ? _buildIconButton(
                    icon: Icons.fingerprint,
                    onTap: () {
                      AppPreferences.triggerHaptic(HapticType.selection);
                      onBiometricPress?.call();
                    },
                    isDark: isDark,
                  )
                : const SizedBox(width: 72, height: 72),
            _buildKeypadButton('0', '', 0, isDark),
            _buildIconButton(
              icon: Icons.backspace_outlined,
              onTap: () {
                AppPreferences.triggerHaptic(HapticType.medium);
                onDeletePress();
              },
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> digits, List<String> subs, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        final val = int.parse(digits[i]);
        return _buildKeypadButton(digits[i], subs[i], val, isDark);
      }),
    );
  }

  Widget _buildKeypadButton(String digit, String sub, int val, bool isDark) {
    return InkWell(
      onTap: () {
        AppPreferences.triggerHaptic(HapticType.light);
        onDigitPress(val);
      },
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.surfaceCardDark : Colors.white,
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.06) : AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              digit,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
            if (sub.isNotEmpty)
              Text(
                sub,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: isDark ? Colors.white : AppColors.gray900,
          ),
        ),
      ),
    );
  }
}

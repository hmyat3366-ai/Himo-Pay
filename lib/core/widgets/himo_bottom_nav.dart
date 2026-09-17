import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../localization/app_strings.dart';
import '../storage/app_preferences.dart';

/// HimoBottomNav — Orange + Charcoal Floating Bottom Navigation Bar
/// Active states: Brand Orange (#FF5E14 / #FF6B26)
/// Inactive states: Muted Slate Gray (#576071 / #8B949E)
/// Center Scan: Circular Orange button with crisp White icon
class HimoBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HimoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = AppColors.brandFor(isDark);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 64,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : Colors.white,
        borderRadius: AppRadius.pillBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded, AppStrings.navHome, isDark, brandColor),
          _buildNavItem(1, Icons.account_balance_wallet_outlined, AppStrings.navWallet, isDark, brandColor),
          _buildCenterScanBtn(context, brandColor),
          _buildNavItem(3, Icons.card_giftcard_rounded, AppStrings.navRewards, isDark, brandColor),
          _buildNavItem(4, Icons.person_outline_rounded, AppStrings.navProfile, isDark, brandColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark, Color brandColor) {
    final isActive = currentIndex == index;
    final color = isActive
        ? brandColor
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight);

    return InkWell(
      onTap: () {
        AppPreferences.triggerHaptic(HapticType.selection);
        onTap(index);
      },
      borderRadius: AppRadius.pillBorder,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? brandColor : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScanBtn(BuildContext context, Color brandColor) {
    return GestureDetector(
      onTap: () {
        AppPreferences.triggerHaptic(HapticType.medium);
        onTap(2);
      },
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: brandColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: brandColor.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/locale_manager.dart';
import '../localization/app_strings.dart';
import 'himo_toast.dart';

class LanguageSelectionModal {
  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Language'.tr('ဘာသာစကား ရွေးချယ်ပါ'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose your preferred language'.tr('အသုံးပြုလိုသော ဘာသာစကားကို ရွေးချယ်ပါ'),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : AppColors.gray500),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Option 1: Myanmar
                _buildLanguageOption(
                  context: ctx,
                  langCode: 'my',
                  flag: '🇲🇲',
                  title: 'မြန်မာစာ (Myanmar)',
                  subtitle: 'Unicode Standard မြန်မာဘာသာ',
                  isSelected: LocaleManager.isMyanmar,
                  isDark: isDark,
                ),
                const SizedBox(height: 12),

                // Option 2: English
                _buildLanguageOption(
                  context: ctx,
                  langCode: 'en',
                  flag: '🇬🇧',
                  title: 'English (United States)',
                  subtitle: 'Default international language',
                  isSelected: !LocaleManager.isMyanmar,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLanguageOption({
    required BuildContext context,
    required String langCode,
    required String flag,
    required String title,
    required String subtitle,
    required bool isSelected,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        LocaleManager.setLocale(langCode);
        Navigator.pop(context);
        HimoToast.show(context, AppStrings.languageChanged);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.12)
              : (isDark ? AppColors.surfaceDark : AppColors.gray100),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGold
                : (isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag Icon Box
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.06) : AppColors.gray200,
                ),
              ),
              alignment: Alignment.center,
              child: Text(flag, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? AppColors.primaryDark : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            // Radio / Checkmark
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryGold : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : AppColors.gray400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

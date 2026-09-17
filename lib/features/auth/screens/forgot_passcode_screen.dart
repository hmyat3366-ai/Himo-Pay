import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/localization/app_strings.dart';

class ForgotPasscodeScreen extends StatefulWidget {
  const ForgotPasscodeScreen({super.key});

  @override
  State<ForgotPasscodeScreen> createState() => _ForgotPasscodeScreenState();
}

class _ForgotPasscodeScreenState extends State<ForgotPasscodeScreen> {
  int _selectedMethod = 0; // 0: SMS, 1: Email, 2: NRC

  final List<Map<String, dynamic>> _methods = [
    {
      'title': 'SMS Verification',
      'titleMy': 'SMS ဖြင့် အတည်ပြုခြင်း',
      'detail': '+95 9*****6548',
      'icon': Icons.sms_rounded,
      'badge': 'Recommended',
      'badgeMy': 'အကြံပြုထားသည်',
    },
    {
      'title': 'Email Verification',
      'titleMy': 'အီးမေးလ်ဖြင့် အတည်ပြုခြင်း',
      'detail': 'u***@himopay.com',
      'icon': Icons.alternate_email_rounded,
    },
    {
      'title': 'National ID (NRC)',
      'titleMy': 'နိုင်ငံသားစိစစ်ရေးကတ် (NRC)',
      'detail': '12/DAGAMA(N)******',
      'icon': Icons.badge_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: HimoAppBar(title: 'Forgot Passcode'.tr('လျှို့ဝှက်ကုဒ် မေ့နေပါသလား')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Security Header
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.25),
                        AppColors.primary.withOpacity(0.08),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Reset Account Passcode'.tr('လျှို့ဝှက်ကုဒ် အသစ် ပြန်သတ်မှတ်မည်'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Select a recovery method to receive your verification code.'
                      .tr('အကောင့်လုံခြုံရေး အတည်ပြုကုဒ် လက်ခံမည့် နည်းလမ်းကို ရွေးချယ်ပါ'),
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // Recovery Methods List
              Text(
                'Verification Methods'.tr('အတည်ပြုမည့် နည်းလမ်းများ'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 12),

              ...List.generate(_methods.length, (index) {
                final m = _methods[index];
                final isSelected = _selectedMethod == index;

                return InkWell(
                  onTap: () => setState(() => _selectedMethod = index),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : const Color(0xFFE5E7EB)),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Method Icon
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.15)
                                : (isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF3F4F6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            m['icon'] as IconData,
                            color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Title & Detail
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      (m['title'] as String).tr(m['titleMy'] as String),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : const Color(0xFF111827),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (m.containsKey('badge')) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        (m['badge'] as String).tr(m['badgeMy'] as String),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                m['detail'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Radio checkmark indicator
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.gray400,
                              width: isSelected ? 6.5 : 1.5,
                            ),
                            color: isSelected ? Colors.white : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Send Verification Code button
              HimoButton(
                text: 'Send Verification Code'.tr('အတည်ပြုကုဒ် ပို့မည်'),
                onPressed: () {
                  final method = _methods[_selectedMethod];
                  Navigator.of(context).pushNamed(
                    '/forgot-otp',
                    arguments: {
                      'title': method['title'],
                      'detail': method['detail'],
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

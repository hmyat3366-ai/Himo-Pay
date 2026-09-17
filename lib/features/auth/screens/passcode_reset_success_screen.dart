import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/localization/app_strings.dart';

class PasscodeResetSuccessScreen extends StatelessWidget {
  const PasscodeResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),

              // Animated Glowing Success Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Ambient Glow
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withOpacity(0.12),
                    ),
                  ),
                  // Mid Ring
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withOpacity(0.2),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.35),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Core Success Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              Text(
                'Passcode Updated!'.tr('လျှို့ဝှက်ကုဒ် အသစ် သတ်မှတ်ပြီးပါပြီ!'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Your Himo account has been successfully updated with your new 6-digit passcode.'
                    .tr('သင်၏ Himo အကောင့် လုံခြုံရေး လျှို့ဝှက်ကုဒ်ကို အောင်မြင်စွာ ပြောင်းလဲပြီးပါပြီ။'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Security Audit Breakdown Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceCardDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildAuditRow(
                      label: 'Security Status'.tr('လုံခြုံရေး အခြေအနေ'),
                      value: 'Protected & Active'.tr('အပြည့်အဝ အကာအကွယ်ရယူထားသည်'),
                      isDark: isDark,
                      isStatus: true,
                    ),
                    const Divider(height: 20),
                    _buildAuditRow(
                      label: 'Updated At'.tr('ပြောင်းလဲချိန်'),
                      value: 'Just now'.tr('ယခုလေးတင်'),
                      isDark: isDark,
                    ),
                    const Divider(height: 20),
                    _buildAuditRow(
                      label: 'Recovery Verification'.tr('အတည်ပြုချက် နည်းလမ်း'),
                      value: 'SMS OTP Verified'.tr('SMS ဖြင့် အတည်ပြုပြီး'),
                      isDark: isDark,
                    ),
                    const Divider(height: 20),
                    _buildAuditRow(
                      label: 'Encryption'.tr('လုံခြုံရေးစနစ်'),
                      value: '256-Bit Hardware Vault',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary CTA: Sign In to Account
              HimoButton(
                text: 'Sign In to My Account'.tr('အကောင့်ထဲသို့ ဝင်မည်'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
              ),
              const SizedBox(height: 10),

              // Secondary: Log in with Passcode
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login-passcode', (route) => false);
                },
                child: Text(
                  'Log In with New Passcode'.tr('လျှို့ဝှက်ကုဒ် အသစ်ဖြင့် ဝင်မည်'),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuditRow({
    required String label,
    required String value,
    required bool isDark,
    bool isStatus = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray400 : const Color(0xFF6B7280),
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 13),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
      ],
    );
  }
}

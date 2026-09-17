import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class UserLevelScreen extends StatelessWidget {
  const UserLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'User Tier Level'.tr('အသုံးပြုသူ အဆင့်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Current Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E1E), Color(0xFF0F0F0F)],
                ),
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CURRENT ACCOUNT LEVEL'.tr('လက်ရှိ အကောင့်အဆင့်'), style: TextStyle(color: AppColors.primaryGold, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('APPROVED'.tr('အတည်ပြုပြီး'), style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Subscriber Level 2'.tr('အဆင့် ၂ အသုံးပြုသူ'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Full KYC Identity Verified with Myanmar National ID'.tr('နိုင်ငံသားစိစစ်ရေးကတ်ပြားဖြင့် အပြည့်အဝ အတည်ပြုပြီး'), style: TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daily Limit: 5,000,000 MMK', style: TextStyle(fontSize: 12, color: Colors.white)),
                      Text('Monthly: 30,000,000 MMK', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('TIER LEVEL COMPARISON'.tr('အဆင့်အလိုက် ကန့်သတ်ချက်များ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            _buildTierRow('Level 1 (Basic)', '500,000 MMK / day', 'Mobile phone registered only', false, isDark),
            const SizedBox(height: 10),
            _buildTierRow('Level 2 (Verified)', '5,000,000 MMK / day', 'NRC ID & Biometrics verified (Current)', true, isDark),
            const SizedBox(height: 10),
            _buildTierRow('Level 3 (Merchant / VIP)', '50,000,000 MMK / day', 'Business registration & tax certificate', false, isDark),
            const SizedBox(height: 24),
            HimoButton(
              text: 'Request Level 3 Merchant Upgrade',
              onPressed: () {
                HimoToast.show(context, 'Upgrade application submitted to Himo compliance team.');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierRow(String title, String limit, String desc, bool isCurrent, bool isDark) {
    return HimoCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? AppColors.primaryGold : (isDark ? AppColors.surfaceDark : AppColors.gray200),
            ),
            child: Icon(
              isCurrent ? Icons.check_rounded : Icons.star_border_rounded,
              color: isCurrent ? Colors.black : AppColors.gray500,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    if (isCurrent)
                      const Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryGold)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(limit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

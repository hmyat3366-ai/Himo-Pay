import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';

class TierBenefitsScreen extends StatelessWidget {
  const TierBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Tier Benefits'.tr('အဆင့်အလိုက် အကျိုးခံစားခွင့်များ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.cardBorder,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C2416), Color(0xFF151515)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Tier Status'.tr('လက်ရှိ အသုံးပြုသူအဆင့်'),
                          style: TextStyle(color: AppColors.gray400, fontSize: 13),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'APPROVED ✓'.tr('အတည်ပြုပြီး ✓'),
                            style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Subscriber Level 2'.tr('အဆင့် ၂ အသုံးပြုသူ'),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Full identity verified with Central Bank of Myanmar regulations.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              const Text('Privileges & Quotas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              _buildBenefitTile(
                icon: Icons.speed,
                title: 'Daily Limit: 5,000,000 MMK',
                desc: 'Level 1 basic accounts have a limit of 500,000 MMK/day.',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildBenefitTile(
                icon: Icons.money_off,
                title: '0% P2P Transfer Fee',
                desc: 'Enjoy free peer-to-peer wallet transfers anywhere in Myanmar.',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildBenefitTile(
                icon: Icons.support_agent,
                title: 'Priority 24/7 VIP Support',
                desc: 'Direct hotline & live chat with dedicated account specialists.',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildBenefitTile(
                icon: Icons.card_giftcard,
                title: 'Higher Cashback Rewards',
                desc: 'Earn 1.5x points on every QR merchant transaction.',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitTile({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return HimoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

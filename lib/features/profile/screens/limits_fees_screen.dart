import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';

class LimitsFeesScreen extends StatelessWidget {
  const LimitsFeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HimoAppBar(title: 'Limits & Fees'.tr('ကန့်သတ်ချက်နှင့် ဝန်ဆောင်ခ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text('DAILY TRANSACTION LIMITS'.tr('နေ့စဉ် ငွေလွှဲ ကန့်သတ်ချက်များ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildLimitRow('P2P Wallet Transfer'.tr('ပိုက်ဆံအိတ်အချင်းချင်း ငွေလွှဲ'), '5,000,000 MMK / day', 'Free (0 MMK)'),
                  const Divider(height: 24),
                  _buildLimitRow('Bank Cash In / Deposit'.tr('ဘဏ်မှ ငွေသွင်း'), '10,000,000 MMK / day', 'Free (0 MMK)'),
                  const Divider(height: 24),
                  _buildLimitRow('Bank Cash Out'.tr('ဘဏ်သို့ ငွေထုတ်'), '3,000,000 MMK / day', '0.2% Fee'),
                  const Divider(height: 24),
                  _buildLimitRow('ATM Cardless Withdrawal'.tr('ATM ကတ်မဲ့ ငွေထုတ်'), '1,000,000 MMK / day', '500 MMK / tx'),
                  const Divider(height: 24),
                  _buildLimitRow('Merchant QR Payment'.tr('ဆိုင်များတွင် QR ပေးချေ'), '10,000,000 MMK / day', 'Free (0 MMK)'),
                  const Divider(height: 24),
                  _buildLimitRow('Bill Payment & Top Up'.tr('ဘေလ်ဆောင်နှင့် ဖုန်းငွေဖြည့်'), '2,000,000 MMK / day', 'Free (0 MMK)'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('FEE STRUCTURE HIGHLIGHTS'.tr('ဝန်ဆောင်ခ သတ်မှတ်ချက်များ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBullet('100% free wallet-to-wallet transfers anywhere in Myanmar.'),
                  const SizedBox(height: 10),
                  _buildBullet('Instant free top-ups from connected KBZ, CB, AYA, and Yoma bank accounts.'),
                  const SizedBox(height: 10),
                  _buildBullet('Transparent 0.2% fee capped at 5,000 MMK for bank withdrawals.'),
                  const SizedBox(height: 10),
                  _buildBullet('No hidden monthly account maintenance or inactivity fees.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitRow(String title, String limit, String fee) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(limit, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(fee, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
        ),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4))),
      ],
    );
  }
}

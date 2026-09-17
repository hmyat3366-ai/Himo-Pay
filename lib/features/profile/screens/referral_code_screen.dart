import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class ReferralCodeScreen extends StatelessWidget {
  const ReferralCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const referralCode = 'HIMO-VIP-7865';

    return Scaffold(
      appBar: HimoAppBar(title: 'Invite & Earn'.tr('မိတ်ဆက်ပြီး ဆုယူမည်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            HimoCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGold.withOpacity(0.15),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primaryGold, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Invite Friends, Earn Cash'.tr('သူငယ်ချင်းများကို ဖိတ်ခေါ်ပြီး ငွေသားဆု ရယူပါ'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Get 1,000 MMK + 50 Himo Points when your friend signs up and completes their first transaction.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  // Referral Code Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          referralCode,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.primaryDark),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: AppColors.primaryGold, size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: referralCode));
                            HimoToast.show(context, 'Referral code copied to clipboard!'.tr('မိတ်ဆက်ကုဒ်ကို ကူးယူပြီးပါပြီ!'));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // QR
                  Container(
                    width: 140,
                    height: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Image.asset('assets/images/illustration_qr_payment.jpg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Stats
            Row(
              children: [
                Expanded(
                  child: HimoCard(
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Friends Joined', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                        SizedBox(height: 4),
                        Text('8 Friends', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HimoCard(
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Earned', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                        SizedBox(height: 4),
                        Text('8,000 MMK', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            HimoButton(
              text: 'Share Invite Link',
              onPressed: () {
                HimoToast.show(context, 'Invite link copied: https://himopay.app/r/$referralCode');
              },
            ),
          ],
        ),
      ),
    );
  }
}

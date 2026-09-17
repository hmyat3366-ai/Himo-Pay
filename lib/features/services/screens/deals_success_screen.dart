import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';

class DealsSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const DealsSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = data?['title'] ?? 'Artisan Café 2-for-1';
    final merchant = data?['merchant'] ?? 'Artisan Coffee Roasters';
    final price = (data?['price'] as num?)?.toInt() ?? 6500;
    final code = data?['code'] ?? 'DL-8492019';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'Group Deal Joined!'.tr('စုပေါင်းဝယ်ယူမှု အောင်မြင်ပါသည်!'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Your voucher is saved in Wallet > My Deals'.tr('သင့်ကူပွန်ကို ပိုက်ဆံအိတ် > ကျွန်ုပ်၏ လျှော့ဈေးများ တွင် သိမ်းဆည်းထားပါသည်'),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(merchant, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                    const Divider(height: 24),
                    // Simulated QR Voucher
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
                    const SizedBox(height: 12),
                    Text('VOUCHER CODE: $code'.tr('ကူပွန်ကုဒ်: $code'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.primaryDark)),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount Paid'.tr('ပေးချေခဲ့သည့် ပမာဏ'), style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                        Text(CurrencyFormatter.formatMMK(price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  HimoToast.show(context, 'Invite link copied to clipboard!'.tr('ဖိတ်ခေါ်လင့်ခ်ကို ကူးယူပြီးပါပြီ!'));
                },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text('Invite Friends to Join Deal'.tr('သူငယ်ချင်းများကို ပါဝင်ရန် ဖိတ်ခေါ်မည်')),
              ),
              const SizedBox(height: 12),
              HimoButton(
                text: 'Done'.tr('ပြီးပါပြီ'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

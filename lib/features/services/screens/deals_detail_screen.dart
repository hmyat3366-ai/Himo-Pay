import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class DealsDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const DealsDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = HimoRepository();

    final title = data?['title'] ?? 'Artisan Café 2-for-1 Specialty Pour-Over';
    final subtitle = data?['subtitle'] ?? 'Buy 1 get 1 free on all single-origin coffees';
    final image = data?['image'] ?? 'assets/images/campaign_photo_cafe.jpg';
    final discountPrice = (data?['discountPrice'] as num?)?.toInt() ?? 6500;
    final originalPrice = (data?['originalPrice'] as num?)?.toInt() ?? 13000;
    final merchant = data?['merchant'] ?? 'Artisan Coffee Roasters';
    final tag = data?['tag'] ?? '50% OFF';

    void joinDeal() {
      if (repo.balance < discountPrice) {
        HimoToast.show(context, 'Insufficient wallet balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
        return;
      }

      repo.deductBalance(discountPrice);
      repo.addPoints((discountPrice / 500).round());
      repo.addTransaction(
        TransactionModel(
          id: 'HM-DL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: 'Group Deal: $title',
          date: 'Just now'.tr('ယခုလေးတင်'),
          amount: discountPrice,
          type: TransactionType.outMoney,
          category: 'Group Deal'.tr('စုပေါင်းဝယ်'),
        ),
      );

      Navigator.of(context).pushReplacementNamed(
        '/deals-success',
        arguments: {
          'title': title,
          'merchant': merchant,
          'price': discountPrice,
          'code': 'DL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        },
      );
    }

    return Scaffold(
      appBar: HimoAppBar(title: 'Deal Details'.tr('လျှော့ဈေး အသေးစိတ်')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(image, height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black)),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 16, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text('Ends in 05h 32m'.tr('ကျန်ချိန် ၀၅နာရီ ၃၂မိနစ်'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.error)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                  const SizedBox(height: 16),
                  HimoCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Group Deal Price'.tr('စုပေါင်းဝယ်ယူမှု ဈေးနှုန်း'), style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                            Text(CurrencyFormatter.formatMMK(discountPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Original Price'.tr('မူရင်းဈေးနှုန်း'), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                            Text(CurrencyFormatter.formatMMK(originalPrice), style: const TextStyle(fontSize: 13, color: AppColors.gray500, decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('TERMS & CONDITIONS'.tr('စည်းကမ်းသတ်မှတ်ချက်များ'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 8),
                  Text(
                    '• Valid for 30 days from date of purchase.\n• Redeemable at all branches during regular opening hours.\n• Present QR voucher in your wallet at cashier counter.\n• Cannot be combined with other ongoing promotions.'.tr('• ဝယ်ယူသည့်နေ့မှ ရက်ပေါင်း ၃၀ အထိ အကျုံးဝင်ပါသည်။\n• ဆိုင်ဖွင့်ချိန်အတွင်း မည်သည့်ဆိုင်ခွဲတွင်မဆို အသုံးပြုနိုင်ပါသည်။\n• ငွေရှင်းကောင်တာတွင် ပိုက်ဆံအိတ်ထဲမှ QR ကုဒ်ကို ပြသပေးပါ။\n• အခြားပရိုမိုးရှင်းများနှင့် တွဲဖက်အသုံးမပြုနိုင်ပါ။'),
                    style: const TextStyle(fontSize: 12, height: 1.6, color: AppColors.gray500),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200)),
              ),
              child: HimoButton(
                text: 'Join Group Deal • '.tr('စုပေါင်းဝယ်ယူမည် • ') + CurrencyFormatter.formatMMK(discountPrice),
                onPressed: joinDeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

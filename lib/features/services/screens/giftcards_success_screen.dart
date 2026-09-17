import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';

class GiftcardsSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const GiftcardsSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = (data?['card'] as Map<String, dynamic>?) ?? {};
    final title = card['title'] ?? 'Gift Card';
    final tier = card['tier'] ?? '\$10 USD';
    final price = (card['priceMMK'] as num?)?.toInt() ?? 35000;
    final code = data?['code'] ?? 'ST-9482-1082-9912';

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
                'Digital Code Delivered!'.tr('ဒစ်ဂျစ်တယ် ကုဒ် ထုတ်ပေးပြီးပါပြီ!'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                '$title ($tier)',
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),
              // Code card with copy button
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('YOUR ACTIVATION CODE'.tr('သင့် အသုံးပြုရန် ကုဒ် (Activation Code)'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.gray100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SelectableText(
                              code,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.primaryDark),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 20, color: AppColors.primaryGold),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              HimoToast.show(context, 'Code copied to clipboard!'.tr('ကုဒ်ကို ကူးယူပြီးပါပြီ!'));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Redeem this key in your account settings or official store.'.tr('ဤကုဒ်ကို သက်ဆိုင်ရာ အကောင့် သို့မဟုတ် စတိုးတွင် ထည့်သွင်း အသုံးပြုနိုင်ပါသည်။'),
                      style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              HimoCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount Paid'.tr('ပေးချေခဲ့သည့် ပမာဏ'), style: TextStyle(fontSize: 13, color: AppColors.gray500)),
                    Text(CurrencyFormatter.formatMMK(price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              HimoButton(
                text: 'Back to Home'.tr('ပင်မစာမျက်နှာသို့'),
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

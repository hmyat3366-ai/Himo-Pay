import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_slide_to_confirm.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';

class TransferReviewScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TransferReviewScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final name = data?['name']?.toString() ?? 'Daw Thida';

    final phone = data?['phone']?.toString() ?? '09 951 884 102';
    final amount = (data?['amount'] as num?)?.toInt() ?? 20000;
    final note = data?['note']?.toString() ?? 'Transfer';
    final isBank = data?['type'] == 'bank';
    final repo = HimoRepository();
    final balanceAfter = (repo.balance - amount).clamp(0, 999999999);

    return Scaffold(
      appBar: HimoAppBar(title: 'Review Transfer'.tr('ငွေလွှဲအချက်အလက် စစ်ဆေးပါ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Big Amount Display
              Text(
                CurrencyFormatter.formatMMK(amount),
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -0.6, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 4),
              Text('Total Amount to Transfer'.tr('စုစုပေါင်း လွှဲပြောင်းမည့်ငွေ'), style: const TextStyle(color: AppColors.gray500, fontSize: 13)),
              const SizedBox(height: AppSpacing.lg),

              // Details Card
              HimoCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildReviewRow(
                      'From Wallet'.tr('ငွေထုတ်မည့် ပိုက်ဆံအိတ်'),
                      'Himo Main Wallet (*******6548)',
                    ),
                    const Divider(height: 20),
                    _buildReviewRow(
                      'Recipient'.tr('လက်ခံသူ'),
                      name,
                      trailingWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        ],
                      ),
                    ),
                    const Divider(height: 20),
                    _buildReviewRow(
                      isBank ? 'Destination'.tr('လွှဲပို့မည့်နေရာ') : 'Mobile Number'.tr('ဖုန်းနံပါတ်'),
                      phone,
                    ),
                    const Divider(height: 20),
                    _buildReviewRow(
                      'Note / Remarks'.tr('မှတ်ချက်'),
                      note,
                    ),
                    const Divider(height: 20),
                    _buildReviewRow(
                      'Transfer Fee'.tr('ငွေလွှဲခ ဝန်ဆောင်ခ'),
                      '0 MMK (Free)'.tr('၀ ကျပ် (အခမဲ့)'),
                      valueColor: AppColors.success,
                    ),
                    const Divider(height: 20),
                    _buildReviewRow(
                      'Balance After'.tr('ကျန်ရှိမည့် လက်ကျန်ငွေ'),
                      CurrencyFormatter.formatMMK(balanceAfter),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Rewards & Protection Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Earn +20 Himo Points on this transaction'.tr('ဤငွေလွှဲမှုအတွက် +20 Himo Points ရရှိပါမည်'),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Security notice
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 13, color: AppColors.gray400),
                  const SizedBox(width: 4),
                  Text(
                    'Protected with end-to-end fintech encryption'.tr('ဘဏ်အဆင့် လုံခြုံရေးစနစ်ဖြင့် အပြည့်အဝ ကာကွယ်ထားပါသည်'),
                    style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              HimoSlideToConfirm(
                label: 'Slide to Authorize'.tr('အတည်ပြုရန် ညာဘက်သို့ ဆွဲပါ'),
                onConfirmed: () {
                  Navigator.of(context).pushNamed(
                    '/transfer-security',
                    arguments: data,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {Color? valueColor, Widget? trailingWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w600)),
        if (trailingWidget != null)
          trailingWidget
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
      ],
    );
  }
}


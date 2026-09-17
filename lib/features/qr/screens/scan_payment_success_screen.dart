import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class ScanPaymentSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const ScanPaymentSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final merchant = data?['merchant'] ?? 'Rangoon Tea House';
    final branch = data?['branch'] ?? 'Downtown Branch';
    final amount = (data?['amount'] as num?)?.toInt() ?? 18500;
    final points = (data?['points'] as num?)?.toInt() ?? 37;
    final txId = 'QR-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

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
                'Payment Successful!'.tr('ငွေပေးချေမှု အောင်မြင်ပါသည်!'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Paid to $merchant',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                CurrencyFormatter.formatMMK(amount),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, color: AppColors.primaryGold, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '+$points ${'Points Added'.tr('ပွိုင့် ရရှိသည်')}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildRow(context, 'Merchant'.tr('ဆိုင်အမည်'), merchant),
                    const Divider(height: 20),
                    _buildRow(context, 'Branch'.tr('ဆိုင်ခွဲ'), branch),
                    const Divider(height: 20),
                    _buildRow(context, 'Transaction ID'.tr('လွှဲပြောင်းမှု ID'), txId),
                    const Divider(height: 20),
                    _buildRow(context, 'Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), valueColor: AppColors.success),
                  ],
                ),
              ),
              const Spacer(flex: 2),
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

  Widget _buildRow(BuildContext context, String label, String value, {Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

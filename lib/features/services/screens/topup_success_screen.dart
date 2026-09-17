import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';

class TopupSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TopupSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final op = data?['operator'] ?? 'ATOM';
    final phone = data?['phone'] ?? '09798123456';
    final amount = (data?['amount'] as num?)?.toInt() ?? 5000;
    final type = data?['type'] ?? 'Airtime';
    final txId = 'TU-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

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
                'Top Up Successful!'.tr('ဖုန်းငွေဖြည့်ခြင်း အောင်မြင်ပါသည်!'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                '${'Sent to'.tr('လွှဲပို့သည့် ဖုန်း')} $phone ($op)',
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
              const SizedBox(height: 28),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildRow(context, 'Service Type'.tr('ဝန်ဆောင်မှု အမျိုးအစား'), type.toString()),
                    const Divider(height: 20),
                    _buildRow(context, 'Operator'.tr('အော်ပရေတာ'), op.toString()),
                    const Divider(height: 20),
                    _buildRow(context, 'Recipient Phone'.tr('လက်ခံသူ ဖုန်းနံပါတ်'), phone.toString()),
                    const Divider(height: 20),
                    _buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),
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
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

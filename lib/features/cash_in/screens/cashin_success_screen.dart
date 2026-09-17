import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_confetti.dart';
import '../../../core/utils/currency_formatter.dart';

class CashinSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const CashinSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final method = data?['method']?.toString() ?? 'KBZ Bank Direct Pay';
    final amount = (data?['amount'] as num?)?.toInt() ?? 50000;
    final txId = data?['id']?.toString() ?? 'HM-CI-774912';
    final date = data?['date']?.toString() ?? 'Just now';
    final remainingBalance = (data?['remainingBalance'] as num?)?.toInt();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
              const SizedBox(height: 20),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Deposit Successful!'.tr('ငွေသွင်းခြင်း အောင်မြင်ပါသည်!'),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Funds have been added to your wallet balance'.tr('သင့်ပိုက်ဆံအိတ်ထဲသို့ ငွေဖြည့်သွင်းပြီးပါပြီ'),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '+ ${CurrencyFormatter.formatMMK(amount)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 16),

              // Points earned badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, color: AppColors.primaryGold, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '+25 Himo Points rewarded!'.tr('+25 Himo Points ရရှိပါသည်!'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              HimoCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildRow(context, 'Payment Method'.tr('ငွေပေးချေသည့် နည်းလမ်း'), method),
                    const Divider(height: 20),
                    _buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),
                    const Divider(height: 20),
                    _buildRow(context, 'Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), date),
                    const Divider(height: 20),
                    _buildRow(context, 'Fee'.tr('ဝန်ဆောင်ခ'), 'Free (0 MMK)'.tr('အခမဲ့ (၀ ကျပ်)'), valueColor: AppColors.success),
                    if (remainingBalance != null) ...[
                      const Divider(height: 20),
                      _buildRow(
                        context,
                        'New Wallet Balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ'),
                        CurrencyFormatter.formatMMK(remainingBalance),
                        valueColor: AppColors.primaryDark,
                      ),
                    ],
                    const Divider(height: 20),
                    _buildRow(context, 'Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), valueColor: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              HimoButton(
                text: 'View Official E-Receipt'.tr('တရားဝင် ပြေစာ ကြည့်မည်'),
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/cashin-receipt',
                    arguments: data,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray300),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/cashin-methods');
                },
                child: Text('Deposit More'.tr('နောက်ထပ် ငွေသွင်းမည်'), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: AppSpacing.sm),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
                child: Text('Back to Home'.tr('ပင်မစာမျက်နှာသို့'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gray600)),
              ),
            ],
          ),
        ),
        const Positioned.fill(
          child: HimoConfettiOverlay(),
        ),
      ],
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
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? Colors.white : AppColors.gray900),
          ),
        ),
      ],
    );
  }
}


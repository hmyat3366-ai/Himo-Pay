import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_confetti.dart';
import '../../../core/utils/currency_formatter.dart';

class TransferSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TransferSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = data?['name']?.toString() ?? 'Daw Thida';
    final phone = data?['phone']?.toString() ?? '09 951 884 102';
    final amount = (data?['amount'] as num?)?.toInt() ?? 20000;
    final txId = data?['id']?.toString() ?? 'HM-TR-849201';
    final note = data?['note']?.toString() ?? 'Transfer';
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

              // Success Icon Badge
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.check_circle_rounded, size: 52, color: AppColors.success),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Transfer Successful!'.tr('ငွေလွှဲခြင်း အောင်မြင်ပါသည်!'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const SizedBox(height: 6),
              Text(
                '${CurrencyFormatter.formatMMK(amount)} ${'sent to '.tr('သို့ လွှဲပြောင်းပေးပို့ပြီးပါပြီ')}$name',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.gray500),
              ),
              const SizedBox(height: 20),

              // Summary Card
              HimoCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildRow(context, 'Recipient'.tr('လက်ခံသူ'), name),
                    const Divider(height: 20),
                    _buildRow(context, 'Destination'.tr('လွှဲပို့သည့် နေရာ'), phone),
                    const Divider(height: 20),
                    _buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),
                    const Divider(height: 20),
                    _buildRow(context, 'Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), date),
                    const Divider(height: 20),
                    _buildRow(context, 'Note'.tr('မှတ်ချက်'), note),
                    if (remainingBalance != null) ...[
                      const Divider(height: 20),
                      _buildRow(
                        context,
                        'Wallet Balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်'),
                        CurrencyFormatter.formatMMK(remainingBalance),
                        valueColor: AppColors.primaryDark,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              HimoButton(
                text: 'View Official E-Receipt'.tr('တရားဝင် ပြေစာ ကြည့်မည်'),
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/transfer-receipt',
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
                  Navigator.of(context).pushReplacementNamed('/transfer-recipient');
                },
                child: Text('Make Another Transfer'.tr('နောက်ထပ် ငွေလွှဲမည်'), style: const TextStyle(fontWeight: FontWeight.w700)),
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
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray500, fontWeight: FontWeight.w600)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: valueColor ?? (isDark ? Colors.white : AppColors.gray900),
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_logo.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';

class TransferReceiptScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TransferReceiptScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = data?['name']?.toString() ?? 'Daw Thida';
    final phone = data?['phone']?.toString() ?? '09 951 884 102';
    final amount = (data?['amount'] as num?)?.toInt() ?? 20000;
    final txId = data?['id']?.toString() ?? 'HM-TR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final note = data?['note']?.toString() ?? 'Transfer';
    final date = data?['date']?.toString() ?? DateFormat('d MMM yyyy, hh:mm a').format(DateTime.now());
    final isBank = data?['type'] == 'bank';

    return Scaffold(
      appBar: HimoAppBar(title: 'Transaction E-Receipt'.tr('ငွေလွှဲပြေစာ (E-Receipt)')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // White / Card Receipt Slip Box
              HimoCard(
                color: isDark ? AppColors.surfaceCardDark : Colors.white,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    // Brand Logo
                    HimoPayLogo(
                      height: 28,
                      variant: isDark ? LogoVariant.dark : LogoVariant.light,
                    ),
                    const SizedBox(height: 6),
                    Text('Official Transfer Receipt'.tr('တရားဝင် ငွေလွှဲပြေစာ'), style: const TextStyle(color: AppColors.gray500, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 10),

                    Text(
                      CurrencyFormatter.formatMMK(amount),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.success, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Payment Successful'.tr('ငွေပေးချေမှု အောင်မြင်သည်'),
                          style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    _buildReceiptItem('Sender'.tr('ငွေလွှဲသူ'), 'HTET MYAT OO (*******6548)'),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Recipient'.tr('ငွေလက်ခံသူ'), name),
                    const SizedBox(height: 10),
                    _buildReceiptItem(isBank ? 'Destination Account'.tr('လွှဲပို့သည့် ဘဏ်အကောင့်') : 'Mobile Number'.tr('ဖုန်းနံပါတ်'), phone),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Payment Method'.tr('ငွေပေးချေသည့် နည်းလမ်း'), isBank ? 'Himo Wallet to Bank (CBM-NET)' : 'Himo Direct Wallet'),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Transfer Fee'.tr('ငွေလွှဲခ'), '0 MMK (Free)'.tr('၀ ကျပ် (အခမဲ့)')),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), date),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Transaction ID'.tr('ငွေလွှဲ ID'), txId),
                    const SizedBox(height: 10),
                    _buildReceiptItem('Note / Remarks'.tr('မှတ်ချက်'), note),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Verification Graphic Simulation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.qr_code_2_rounded, size: 36, color: AppColors.primaryDark),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Digitally Verified by Himo Pay'.tr('Himo Pay မှ ဒစ်ဂျစ်တယ်စနစ်ဖြင့် အတည်ပြုပြီး'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                            Text('Ref: SEC-${txId.replaceAll('HM-TR-', '')}', style: const TextStyle(fontSize: 9, color: AppColors.gray500)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Share & Save Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 18, color: AppColors.primary),
                      label: Text('Share'.tr('မျှဝေမည်'), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      onPressed: () {
                        HimoToast.show(context, 'Receipt shared successfully'.tr('ပြေစာ မျှဝေပြီးပါပြီ'));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HimoButton(
                      text: 'Save Image'.tr('သိမ်းဆည်းမည်'),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      onPressed: () {
                        HimoToast.show(context, 'Receipt saved to Photo Gallery'.tr('ပြေစာကို ဓာတ်ပုံထဲ သိမ်းဆည်းပြီးပါပြီ'));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              HimoButton(
                text: 'Back to Home'.tr('ပင်မစာမျက်နှာသို့'),
                isPrimary: false,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}


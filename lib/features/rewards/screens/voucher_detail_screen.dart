import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../data/repositories/himo_repository.dart';

class VoucherDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const VoucherDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = HimoRepository();

    final title = data?['title'] ?? '5,000 MMK Grab Ride Discount';
    final partner = data?['partner'] ?? 'Grab Myanmar';
    final costPts = (data?['costPts'] as num?)?.toInt() ?? 450;
    final validUntil = data?['validUntil'] ?? '31 Oct 2026';
    final code = data?['code'] ?? 'GRAB-HIMO-5000';

    void redeem() {
      if (repo.points < costPts) {
        HimoToast.show(context, 'Insufficient points to redeem this voucher', isError: true);
        return;
      }

      repo.deductPoints(costPts);
      HimoToast.show(context, '🎉 Voucher redeemed! Saved to your Wallet Vouchers.');
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: HimoAppBar(title: 'Voucher Details'.tr('ကူပွန် အသေးစိတ်')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                          child: const Icon(Icons.confirmation_num_outlined, color: AppColors.primaryGold, size: 28),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$partner • Valid until $validUntil',
                          style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                        ),
                        const Divider(height: 32),
                        // Barcode
                        Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  30,
                                  (i) => Container(
                                    width: (i % 2 == 0) ? 3 : 2,
                                    height: 38,
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              code,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.primaryDark),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primaryGold),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: code));
                                HimoToast.show(context, 'Voucher code copied!');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('HOW TO REDEEM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Copy the code or present the barcode directly at the checkout counter.\n2. For Grab or online apps, paste this voucher code in the Promo section before placing your order.\n3. One voucher per order. Non-refundable and cannot be exchanged for cash.',
                    style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.gray500),
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
                text: 'Redeem Voucher ($costPts PTS)',
                onPressed: redeem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

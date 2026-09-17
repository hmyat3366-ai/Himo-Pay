import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_logo.dart';

class AboutHimopayScreen extends StatelessWidget {
  const AboutHimopayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'About Himo Pay'.tr('Himo Pay အကြောင်း')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandOrange.withOpacity(0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const HimoPayIcon(size: 56),
                  ),
                  const SizedBox(height: 16),
                  HimoPayLogo(
                    height: 28,
                    variant: isDark ? LogoVariant.dark : LogoVariant.light,
                  ),
                  const SizedBox(height: 4),
                  const Text('Version 2.4.0 (Build 2026.09.15)', style: TextStyle(fontSize: 12, color: AppColors.gray500)),
                  const SizedBox(height: 4),
                  const Text('Xia Power Digital Technology Co., Ltd.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            HimoCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OFFICIAL LICENSING & REGULATION'.tr('တရားဝင် လိုင်စင်နှင့် ကြီးကြပ်ခွင့်ပြုချက်'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 10),
                  const Text(
                    'Himo Pay is a legally authorized mobile financial services provider licensed by the Central Bank of Myanmar under MFS License No. MFS-018/2024.',
                    style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.gray500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'All client funds are 100% held in segregated trust accounts with authorized partner commercial banks in accordance with CBM financial regulations.',
                    style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.gray500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Terms of Service', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => HimoToast.show(context, 'Opening Terms of Service...'),
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.gray200),
                  ListTile(
                    title: const Text('Privacy & Data Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => HimoToast.show(context, 'Opening Privacy Policy...'),
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.gray200),
                  ListTile(
                    title: const Text('Open Source Licenses', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => HimoToast.show(context, 'Opening Open Source Licenses...'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                '© 2026 Xia Power. All Rights Reserved.',
                style: TextStyle(fontSize: 11, color: AppColors.gray500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

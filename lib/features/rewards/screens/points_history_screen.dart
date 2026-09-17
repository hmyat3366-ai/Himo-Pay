import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = HimoRepository();
    final points = repo.points;

    final history = [
      {'title': 'Daily Check-in Streak', 'pts': '+20', 'time': 'Today, 9:00 AM', 'isEarn': true},
      {'title': 'QR Merchant Payment (Rangoon Tea House)', 'pts': '+37', 'time': 'Yesterday, 8:15 PM', 'isEarn': true},
      {'title': 'Voucher Redemption (Grab 5,000 MMK)', 'pts': '-450', 'time': '12 Sep 2026', 'isEarn': false},
      {'title': 'Weekend 2X Booster Reward', 'pts': '+200', 'time': '10 Sep 2026', 'isEarn': true},
      {'title': 'Mobile Top Up Airtime (ATOM)', 'pts': '+10', 'time': '08 Sep 2026', 'isEarn': true},
      {'title': 'New Member Welcome Bonus', 'pts': '+500', 'time': '01 Sep 2026', 'isEarn': true},
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Points History'.tr('ပွိုင့်မှတ်တမ်း')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            HimoCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL AVAILABLE POINTS'.tr('စုစုပေါင်း ရရှိထားသော ပွိုင့်'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 6),
                  Text('$points PTS', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: AppColors.primaryDark)),
                  const SizedBox(height: 4),
                  Text('Equivalent cash value: ${CurrencyFormatter.formatMMK(points * 10)}', style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('POINTS ACTIVITY'.tr('ပွိုင့် လှုပ်ရှားမှုမှတ်တမ်း'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
            const SizedBox(height: 10),
            ...history.map((h) {
              final isEarn = h['isEarn'] as bool;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HimoCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isEarn ? AppColors.success.withOpacity(0.12) : AppColors.error.withOpacity(0.12),
                        ),
                        child: Icon(
                          isEarn ? Icons.add_rounded : Icons.remove_rounded,
                          color: isEarn ? AppColors.success : AppColors.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1),
                            const SizedBox(height: 2),
                            Text(h['time'] as String, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                          ],
                        ),
                      ),
                      Text(
                        h['pts'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isEarn ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

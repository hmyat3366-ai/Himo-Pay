import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../data/repositories/himo_repository.dart';

class SecretShopScreen extends StatelessWidget {
  const SecretShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = HimoRepository();

    final drops = [
      {
        'title': 'Mystery Gold Reward Box',
        'desc': 'Contains guaranteed cash reward between 5,000 - 50,000 MMK',
        'pts': 800,
        'tag': 'LIMITED 50 LEFT',
        'icon': Icons.inventory_2_rounded,
        'color': AppColors.primaryGold,
      },
      {
        'title': 'Yangon Int Airport VIP Lounge Pass',
        'desc': 'Free premium lounge entry, gourmet buffet & shower facilities',
        'pts': 1500,
        'tag': 'VIP ONLY',
        'icon': Icons.flight_takeoff_rounded,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'The Strand 5-Star Afternoon Tea for 2',
        'desc': 'Traditional colonial high-tea set at The Strand Yangon',
        'pts': 2200,
        'tag': 'EXCLUSIVE',
        'icon': Icons.local_cafe_rounded,
        'color': Colors.amber,
      },
    ];

    void redeemDrop(Map<String, dynamic> drop) {
      final cost = drop['pts'] as int;
      if (repo.points < cost) {
        HimoToast.show(context, 'You need $cost points to unlock this mystery drop', isError: true);
        return;
      }

      repo.deductPoints(cost);
      HimoToast.show(context, '🎉 Unlocked "${drop['title']}"! Voucher added to your wallet.');
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFAFAFA),
      appBar: HimoAppBar(title: 'Himo Secret Shop'.tr('Himo လျှို့ဝှက် အရောင်းဆိုင်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E1C0C), Color(0xFF140D07)],
                ),
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.vpn_key_rounded, color: AppColors.primaryGold, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EXCLUSIVE MEMBER VAULT', style: TextStyle(color: AppColors.primaryGold, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                        const SizedBox(height: 2),
                        Text('Your Balance: ${repo.points} PTS', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('LIMITED TIME DROPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 12),
            ...drops.map((drop) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: HimoCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (drop['color'] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              drop['tag'] as String,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: drop['color'] as Color),
                            ),
                          ),
                          Text(
                            '${drop['pts']} PTS',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(drop['icon'] as IconData, color: drop['color'] as Color, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(drop['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(drop['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.3)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      HimoButton(
                        text: 'Unlock Drop (${drop['pts']} PTS)',
                        onPressed: () => redeemDrop(drop),
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

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';

class DealsBrowseScreen extends StatelessWidget {
  const DealsBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final deals = [
      {
        'id': 'deal-1',
        'title': 'Artisan Café 2-for-1 Specialty Pour-Over',
        'subtitle': 'Buy 1 get 1 free on all single-origin coffees',
        'image': 'assets/images/campaign_photo_cafe.jpg',
        'tag': '50% OFF',
        'discountPrice': 6500,
        'originalPrice': 13000,
        'merchant': 'Artisan Coffee Roasters',
        'groupNeeded': 2,
        'groupJoined': 1,
      },
      {
        'id': 'deal-2',
        'title': 'Gourmet Wagyu Burger & Truffle Fries Set',
        'subtitle': 'Includes craft iced tea and dessert',
        'image': 'assets/images/e2be955361a20049e8872775ba9692e2.jpg',
        'tag': '35% OFF',
        'discountPrice': 12000,
        'originalPrice': 18500,
        'merchant': 'The Prime Grill',
        'groupNeeded': 3,
        'groupJoined': 2,
      },
      {
        'id': 'deal-3',
        'title': 'Luxury Spa & Aroma Massage 60 Min',
        'subtitle': 'Full body relaxation with natural oils',
        'image': 'assets/images/event_visual_rewards.jpg',
        'tag': '40% OFF',
        'discountPrice': 24000,
        'originalPrice': 40000,
        'merchant': 'Zenith Wellness Club',
        'groupNeeded': 4,
        'groupJoined': 3,
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Himo Group Deals'.tr('Himo စုပေါင်းဝယ်ယူမှု')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Group Buying & Flash Discounts'.tr('စုပေါင်းဝယ်ယူမှုနှင့် အထူးလျှော့ဈေးများ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Team up with friends or other Himo users to unlock huge discounts'.tr('သူငယ်ချင်းများ သို့မဟုတ် အခြားအသုံးပြုသူများနှင့် စုပေါင်းပြီး အထူးလျှော့ဈေးများ ရယူပါ'),
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            ...deals.map((deal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HimoCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/deals-detail',
                      arguments: deal,
                    );
                  },
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              image: DecorationImage(
                                image: AssetImage(deal['image'] as String),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGold,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                deal['tag'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deal['title'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              deal['subtitle'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      CurrencyFormatter.formatMMK(deal['discountPrice'] as int),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      CurrencyFormatter.formatMMK(deal['originalPrice'] as int),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${deal['groupJoined']}/${deal['groupNeeded']} ${'Joined'.tr('ဦး ပါဝင်ပြီး')}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

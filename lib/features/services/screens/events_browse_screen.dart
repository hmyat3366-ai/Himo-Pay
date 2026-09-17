import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class EventsBrowseScreen extends StatelessWidget {
  const EventsBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final events = [
      {
        'id': 'evt-1',
        'title': 'Yangon Tech Innovators Summit 2026',
        'venue': 'Lotte Hotel Grand Ballroom • 9:00 AM',
        'date': '26 SEP 2026',
        'image': 'assets/images/event_visual_rewards.jpg',
        'price': 45000,
        'tag': 'TECH & AI',
      },
      {
        'id': 'evt-2',
        'title': 'Myanmar Indie Music Showcase Live',
        'venue': 'The Secretariat Courtyard • 6:00 PM',
        'date': '04 OCT 2026',
        'image': 'assets/images/e2be955361a20049e8872775ba9692e2.jpg',
        'price': 25000,
        'tag': 'CONCERT',
      },
      {
        'id': 'evt-3',
        'title': 'National Barista Championship & Expo',
        'venue': 'Fortune Plaza Hall A • 10:00 AM',
        'date': '12 OCT 2026',
        'image': 'assets/images/campaign_photo_cafe.jpg',
        'price': 15000,
        'tag': 'F&B EXPO',
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Events & Passes'.tr('ပွဲများနှင့် လက်မှတ်များ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Upcoming Concerts & Summits'.tr('လာမည့် ပွဲများနှင့် ဖျော်ဖြေပွဲများ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Book e-passes instantly with contact-free QR check-in'.tr('QR ကုဒ်ဖြင့် အလွယ်တကူ ဝင်ရောက်နိုင်သော e-လက်မှတ်များ ဝယ်ယူပါ'),
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            ...events.map((evt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HimoCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/events-detail',
                      arguments: evt,
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
                                image: AssetImage(evt['image'] as String),
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
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                evt['date'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.primaryGold),
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
                              evt['title'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              evt['venue'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CurrencyFormatter.formatMMK(evt['price'] as int),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                                ),
                                Row(
                                  children: [
                                    Text('Book Pass'.tr('လက်မှတ်ဝယ်မည်'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGold)),
                                    const Icon(Icons.chevron_right, size: 16, color: AppColors.primaryGold),
                                  ],
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

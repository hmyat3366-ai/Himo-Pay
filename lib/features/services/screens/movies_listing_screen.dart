import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class MoviesListingScreen extends StatefulWidget {
  const MoviesListingScreen({super.key});

  @override
  State<MoviesListingScreen> createState() => _MoviesListingScreenState();
}

class _MoviesListingScreenState extends State<MoviesListingScreen> {
  int _selectedTab = 0; // 0: Now Showing, 1: Coming Soon

  final List<Map<String, dynamic>> _nowShowing = [
    {
      'title': 'Inception: IMAX 70mm Special',
      'genre': 'Sci-Fi / Action • 2h 28m',
      'rating': '★ 8.8 / 10',
      'cinema': 'JCGV Junction City • Hall 1 IMAX',
      'times': ['1:00 PM', '4:30 PM', '7:45 PM'],
      'price': 11000,
      'image': 'assets/images/campaign_photo_cafe.jpg',
    },
    {
      'title': 'Dune: Part Two Director Cut',
      'genre': 'Adventure / Epic • 2h 46m',
      'rating': '★ 8.9 / 10',
      'cinema': 'Mega Ace Cinema • Premium Dolby Atmos',
      'times': ['2:15 PM', '5:45 PM', '9:00 PM'],
      'price': 9500,
      'image': 'assets/images/e2be955361a20049e8872775ba9692e2.jpg',
    },
    {
      'title': 'Spirited Away Studio Ghibli Fest',
      'genre': 'Animation / Fantasy • 2h 05m',
      'rating': '★ 8.6 / 10',
      'cinema': 'Mingalar Sanpya Cineplex',
      'times': ['11:30 AM', '3:00 PM', '6:30 PM'],
      'price': 8500,
      'image': 'assets/images/event_visual_rewards.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Cinema & Movies'.tr('ရုပ်ရှင်နှင့် ရုပ်ရှင်ရုံများ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Tabs: Now Showing vs Coming Soon
            Row(
              children: [
                _buildTab('Now Showing'.tr('ရုံတင်ပြသနေဆဲ'), 0, isDark),
                const SizedBox(width: 8),
                _buildTab('Coming Soon'.tr('မကြာမီ လာမည်'), 1, isDark),
              ],
            ),
            const SizedBox(height: 16),
            ..._nowShowing.map((m) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: HimoCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/movies-seats',
                      arguments: m,
                    );
                  },
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          m['image'] as String,
                          width: 84,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['title'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m['genre'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m['cinema'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.primaryGold, fontWeight: FontWeight.w600),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CurrencyFormatter.formatMMK(m['price'] as int),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGold,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Select Seats'.tr('ထိုင်ခုံ ရွေးမည်'),
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black),
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

  Widget _buildTab(String title, int idx, bool isDark) {
    final isSelected = _selectedTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.surfaceElevatedDark : AppColors.gray100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

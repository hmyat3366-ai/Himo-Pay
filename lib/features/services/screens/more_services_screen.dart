import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/localization/app_strings.dart';

class MoreServicesScreen extends StatelessWidget {
  const MoreServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final moneyServices = [
      {'title': 'Send Money'.tr('ငွေလွှဲမည်'), 'icon': Icons.swap_horiz_rounded, 'route': '/transfer-recipient', 'color': AppColors.primaryGold},
      {'title': 'Deposit'.tr('ငွေသွင်း'), 'icon': Icons.add_circle_outline_rounded, 'route': '/cashin-methods', 'color': AppColors.success},
      {'title': 'Cash Out'.tr('ငွေထုတ်'), 'icon': Icons.arrow_circle_down_rounded, 'route': '/cashout-methods', 'color': Colors.deepOrange},
      {'title': 'Scan QR'.tr('QR စကင်'), 'icon': Icons.qr_code_scanner_rounded, 'route': '/scan-qr', 'color': Colors.blue},
    ];

    final utilityServices = [
      {'title': 'Top Up'.tr('ဖုန်းငွေဖြည့်'), 'icon': Icons.phone_android_rounded, 'route': '/topup-main', 'color': Colors.purple},
      {'title': 'Bills'.tr('ဘေလ်ဆောင်'), 'icon': Icons.receipt_long_rounded, 'route': '/bills-categories', 'color': Colors.amber},
      {'title': 'Internet'.tr('အင်တာနက်'), 'icon': Icons.wifi_rounded, 'route': '/bills-categories', 'color': Colors.cyan},
      {'title': 'Solar Power'.tr('ဆိုလာစွမ်းအင်'), 'icon': Icons.solar_power_rounded, 'route': '/bills-categories', 'color': Colors.orange},
    ];

    final lifestyleServices = [
      {'title': 'Cinema'.tr('ရုပ်ရှင်'), 'icon': Icons.movie_outlined, 'route': '/movies-listing', 'color': Colors.pink},
      {'title': 'Events'.tr('ပွဲလက်မှတ်'), 'icon': Icons.confirmation_number_outlined, 'route': '/events-browse', 'color': Colors.indigo},
      {'title': 'Group Deals'.tr('စုပေါင်းဝယ်'), 'icon': Icons.local_offer_outlined, 'route': '/deals-browse', 'color': Colors.teal},
      {'title': 'Gift Cards'.tr('ဂိမ်းကတ်'), 'icon': Icons.card_giftcard_rounded, 'route': '/giftcards-catalog', 'color': Colors.redAccent},
    ];

    final financeServices = [
      {'title': 'Insurance'.tr('အာမခံ'), 'icon': Icons.shield_outlined, 'route': '/insurance-plans', 'color': Colors.blueGrey},
      {'title': 'My Tickets'.tr('လက်မှတ်များ'), 'icon': Icons.airplane_ticket_outlined, 'route': '/my-tickets', 'color': AppColors.primaryGold},
      {'title': 'Cards'.tr('ကတ်များ'), 'icon': Icons.credit_card_outlined, 'route': '/wallet-cards', 'color': Colors.deepPurple},
      {'title': 'Rewards'.tr('ဆုလာဘ်'), 'icon': Icons.stars_rounded, 'route': '/rewards', 'color': Colors.amber},
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'All Services'.tr('ဝန်ဆောင်မှု အားလုံး')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _buildSection(context, 'Transfers & Money'.tr('ငွေလွှဲနှင့် ငွေကြေး'), moneyServices, isDark),
            const SizedBox(height: 24),
            _buildSection(context, 'Bills & Utilities'.tr('ဘေလ်နှင့် အသုံးစရိတ်'), utilityServices, isDark),
            const SizedBox(height: 24),
            _buildSection(context, 'Lifestyle & Entertainment'.tr('လူနေမှုဘဝနှင့် ဖျော်ဖြေရေး'), lifestyleServices, isDark),
            const SizedBox(height: 24),
            _buildSection(context, 'Finance & Rewards'.tr('ဘဏ္ဍာရေးနှင့် ဆုလာဘ်'), financeServices, isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Map<String, dynamic>> items, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, i) {
            final item = items[i];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(item['route'] as String);
              },
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.gray200,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

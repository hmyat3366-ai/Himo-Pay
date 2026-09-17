import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/localization/app_strings.dart';

class BillsCategoriesScreen extends StatelessWidget {
  const BillsCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {
        'title': 'Electricity Bill',
        'title_my': 'လျှပ်စစ်မီတာခ',
        'provider': 'YESC / MESC (Yangon & Mandalay Supply)',
        'provider_my': 'YESC / MESC (ရန်ကုန်နှင့် မန္တလေး လျှပ်စစ်)',
        'icon': Icons.bolt_rounded,
        'color': Colors.amber,
      },
      {
        'title': 'Water & Municipal',
        'title_my': 'ရေခွန်နှင့် စည်ပင်',
        'provider': 'YCDC Municipal Water Supply Dept',
        'provider_my': 'YCDC စည်ပင် ရေပေးဝေရေးဌာန',
        'icon': Icons.water_drop_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Broadband & Fiber',
        'title_my': 'အင်တာနက်နှင့် ဖိုင်ဘာ',
        'provider': 'MPT Fiber, 5BB Broadband, Myanmar Net',
        'provider_my': 'MPT Fiber, 5BB Broadband, Myanmar Net',
        'icon': Icons.router_rounded,
        'color': Colors.indigo,
      },
      {
        'title': 'Xia Power Solar Energy',
        'title_my': 'Xia Power ဆိုလာစွမ်းအင်',
        'provider': 'Xia Off-Grid & Hybrid Solar Subscription',
        'provider_my': 'Xia ဆိုလာစနစ် လစဉ်ကြေး',
        'icon': Icons.solar_power_rounded,
        'color': AppColors.primaryGold,
      },
      {
        'title': 'Education & Tuition',
        'title_my': 'ကျောင်းလခနှင့် ပညာရေး',
        'provider': 'International School & Universities',
        'provider_my': 'နိုင်ငံတကာကျောင်းများနှင့် တက္ကသိုလ်များ',
        'icon': Icons.school_rounded,
        'color': Colors.purple,
      },
      {
        'title': 'Public Service & Tax',
        'title_my': 'အခွန်နှင့် အစိုးရဌာန',
        'provider': 'Internal Revenue & Road Transport Dept',
        'provider_my': 'ပြည်တွင်းအခွန်နှင့် ကုန်းလမ်းပို့ဆောင်ရေး',
        'icon': Icons.account_balance_rounded,
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Pay Bills'.tr('ဘေလ်ဆောင်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Select Bill Category'.tr('ဘေလ်အမျိုးအစား ရွေးချယ်ပါ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pay your utility bills directly with 0% processing fee'.tr('မည်သည့် ဝန်ဆောင်ခမှ မလိုဘဲ အသုံးစရိတ်ဘေလ်များ အလွယ်တကူ ပေးချေပါ'),
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            ...categories.map((cat) {
              final title = (cat['title'] as String).tr(cat['title_my'] as String);
              final provider = (cat['provider'] as String).tr(cat['provider_my'] as String);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HimoCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/bills-provider',
                      arguments: {
                        'category': title,
                        'provider': provider,
                      },
                    );
                  },
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text(
                              provider,
                              style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.gray400),
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

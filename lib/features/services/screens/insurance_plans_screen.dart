import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class InsurancePlansScreen extends StatelessWidget {
  const InsurancePlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final plans = [
      {
        'title': 'Personal Accident Protection',
        'tag': 'Recommended',
        'coverage': 'Coverage up to 10,000,000 MMK for accidental injuries and hospital bills.',
        'premium': 12000,
        'period': '/ year',
        'underwriter': 'IKBZ Insurance Partner',
        'icon': Icons.security_rounded,
      },
      {
        'title': 'Smartphone Screen & Liquid Damage',
        'tag': 'Popular',
        'coverage': 'Reimbursement up to 350,000 MMK for shattered screens and accidental liquid spills.',
        'premium': 8500,
        'period': '/ year',
        'underwriter': 'GGI Tokong Insurance',
        'icon': Icons.phone_android_rounded,
      },
      {
        'title': 'Nationwide Travel Care',
        'tag': 'Instant Active',
        'coverage': 'Medical emergency & trip delay compensation up to 5,000,000 MMK per trip.',
        'premium': 4500,
        'period': '/ trip',
        'underwriter': 'AYA Sompo Insurance',
        'icon': Icons.flight_takeoff_rounded,
      },
      {
        'title': 'Dengue & Seasonal Health Shield',
        'tag': 'Health Plus',
        'coverage': 'Daily hospital cash allowance 50,000 MMK up to 30 days per policy cycle.',
        'premium': 6000,
        'period': '/ 6 months',
        'underwriter': 'Myanma Insurance',
        'icon': Icons.medical_services_outlined,
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Micro-Insurance'.tr('အသေးစား အာမခံ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Affordable Protection Plans'.tr('သင့်တင့်မျှတသော အကာအကွယ် အစီအစဉ်များ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Peace of mind protection with paperless instant policy activation'.tr('စာရွက်စာတမ်း မလိုဘဲ ချက်ချင်း အကာအကွယ် ရယူနိုင်သော အာမခံများ'),
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            ...plans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: HimoCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/insurance-detail',
                      arguments: plan,
                    );
                  },
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(plan['icon'] as IconData, color: AppColors.primaryGold, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                plan['title'] as String,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              plan['tag'] as String,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        plan['coverage'] as String,
                        style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            plan['underwriter'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                          ),
                          Row(
                            children: [
                              Text(
                                CurrencyFormatter.formatMMK(plan['premium'] as int),
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                              ),
                              Text(
                                ' ${plan['period']}',
                                style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                              ),
                            ],
                          ),
                        ],
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

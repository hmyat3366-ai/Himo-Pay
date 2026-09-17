import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';

class CashinMethodsScreen extends StatelessWidget {
  const CashinMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final linkedBanks = [
      {
        'title': 'KBZ Bank Direct Pay',
        'account': 'KBZ •••• 4912',
        'desc': 'Instant 1-click deposit • 0% Fee',
        'code': 'KBZ',
        'color': const Color(0xFF003882),
        'badge': 'Linked - Instant',
      },
      {
        'title': 'AYA iBanking / AYA Pay',
        'account': 'AYA •••• 8201',
        'desc': 'Direct linked bank account • 0% Fee',
        'code': 'AYA',
        'color': const Color(0xFFED1C24),
        'badge': 'Linked - Instant',
      },
      {
        'title': 'CB Bank PayWay',
        'account': 'CB •••• 1134',
        'desc': 'CB Pay direct debit • 0% Fee',
        'code': 'CB',
        'color': const Color(0xFFF37021),
        'badge': 'Linked - Instant',
      },
    ];

    final otherMethods = [
      {
        'title': 'MPU Local Debit Card',
        'desc': 'KBZ, CB, AYA, uab, MAB, A Bank cards',
        'code': 'MPU',
        'color': const Color(0xFF0B5394),
        'badge': 'Local Cards',
      },
      {
        'title': 'Visa / Mastercard',
        'desc': 'International and local credit/debit cards',
        'code': 'CARD',
        'color': const Color(0xFF1A1F71),
        'badge': 'Global Cards',
      },
      {
        'title': 'Himo Authorized Agent Counter',
        'desc': 'Over 12,000 partner agent stores nationwide',
        'code': 'AGENT',
        'color': AppColors.primary,
        'badge': 'Over-The-Counter',
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Cash In (Deposit)'.tr('ငွေသွင်းမည်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            Text(
              'Linked Bank Accounts (Instant)'.tr('ချိတ်ဆက်ထားသော ဘဏ်အကောင့်များ (ချက်ချင်းငွေသွင်း)'),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 10),
            ...linkedBanks.map((m) => _buildMethodItem(context, m, isDark)),

            const SizedBox(height: 18),
            Text(
              'Other Deposit Methods'.tr('အခြား ငွေသွင်းနည်းလမ်းများ'),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? AppColors.gray300 : AppColors.gray700),
            ),
            const SizedBox(height: 10),
            ...otherMethods.map((m) => _buildMethodItem(context, m, isDark)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodItem(BuildContext context, Map<String, dynamic> m, bool isDark) {
    final title = m['title'] as String;
    final code = m['code'] as String;
    final color = m['color'] as Color;
    final desc = m['desc'] as String;
    final badge = m['badge'] as String;
    final account = m['account'] as String?;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: HimoCard(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/cashin-amount',
            arguments: {
              'method': title,
              'code': code,
              'account': account,
              'badge': badge,
            },
          );
        },
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  code,
                  style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 11),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (account != null) ...[
                    Text(account, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                    const SizedBox(height: 2),
                  ],
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}


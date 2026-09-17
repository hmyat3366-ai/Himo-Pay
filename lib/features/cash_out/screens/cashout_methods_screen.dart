import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';

class CashoutMethodsScreen extends StatelessWidget {
  const CashoutMethodsScreen({super.key});

  void _onSelectBank(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final banks = [
          {'name': 'KBZ Bank', 'acc': '•••• 4912', 'code': 'KBZ', 'color': const Color(0xFF003882)},
          {'name': 'AYA Bank', 'acc': '•••• 8201', 'code': 'AYA', 'color': const Color(0xFFED1C24)},
          {'name': 'CB Bank', 'acc': '•••• 1134', 'code': 'CB', 'color': const Color(0xFFF37021)},
          {'name': 'Yoma Bank', 'acc': '•••• 9901', 'code': 'YOMA', 'color': const Color(0xFF9E1B32)},
        ];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceCardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('Select Destination Bank'.tr('ငွေလွှဲလက်ခံမည့် ဘဏ် ရွေးချယ်ပါ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              ...banks.map((b) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HimoCard(
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed(
                        '/cashout-amount',
                        arguments: {
                          'type': 'bank',
                          'method': 'Withdraw to ${b['name']}',
                          'destination': '${b['name']} (${b['acc']})',
                          'account': b['acc'],
                          'bankCode': b['code'],
                          'feeType': 'percent',
                          'feeRate': 0.002,
                        },
                      );
                    },
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: (b['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                          child: Text(b['code'] as String, style: TextStyle(fontWeight: FontWeight.w900, color: b['color'] as Color, fontSize: 11)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              Text('Account: ${b['acc']}', style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.gray400),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _onSelectAtm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final atms = ['KBZ Bank ATM Network', 'CB Bank ATM Network', 'AYA Bank ATM Network'];

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceCardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Text('Select ATM Bank Network'.tr('ATM စက် ရွေးချယ်ပါ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Cardless withdrawal via 6-digit dynamic OTP'.tr('ကတ်မလိုဘဲ ဂဏန်း ၆ လုံး OTP ဖြင့် ငွေထုတ်ယူနိုင်ပါသည်'), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
              const SizedBox(height: 14),
              ...atms.map((atm) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HimoCard(
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed(
                        '/cashout-amount',
                        arguments: {
                          'type': 'atm',
                          'method': 'ATM Cardless Withdrawal',
                          'destination': atm,
                          'feeType': 'fixed',
                          'fixedFee': 500,
                        },
                      );
                    },
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        const Icon(Icons.local_atm_rounded, color: AppColors.primaryGold, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Text(atm, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                        const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.gray400),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _onSelectAgent(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/cashout-amount',
      arguments: {
        'type': 'agent',
        'method': 'Nearby Cash Out Agent',
        'destination': 'Himo Authorized Agent (Hledan Central - AG-8812)',
        'feeType': 'percent',
        'feeRate': 0.002,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final methods = [
      {
        'title': 'Withdraw to Bank',
        'sub': 'KBZ, CB, AYA, Yoma (1-2 mins)',
        'icon': Icons.account_balance_outlined,
        'fee': 'Fee 0.2%',
        'action': () => _onSelectBank(context),
      },
      {
        'title': 'Nearby Cash Out Agent',
        'sub': 'Over 12,000 agents nationwide with cashout QR',
        'icon': Icons.storefront_outlined,
        'fee': 'Fee 0.2%',
        'action': () => _onSelectAgent(context),
      },
      {
        'title': 'ATM Cardless Withdrawal',
        'sub': 'Generate 6-digit OTP code for any ATM',
        'icon': Icons.local_atm_outlined,
        'fee': 'Fee 500 MMK',
        'action': () => _onSelectAtm(context),
      },
    ];

    return Scaffold(
      appBar: HimoAppBar(title: 'Cash Out Options'.tr('ငွေထုတ်မည့် နည်းလမ်းများ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              'Select Withdrawal Method'.tr('ငွေထုတ်မည့် နည်းလမ်း ရွေးချယ်ပါ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Withdraw money securely from your Himo wallet'.tr('သင့် Himo ပိုက်ဆံအိတ်မှ ငွေကို စိတ်ချလုံခြုံစွာ ထုတ်ယူပါ'),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            ...methods.map((m) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HimoCard(
                  onTap: m['action'] as VoidCallback,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGold.withOpacity(0.12),
                        ),
                        child: Icon(m['icon'] as IconData, color: AppColors.primaryGold, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['title'] as String,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              m['sub'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m['fee'] as String,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, color: isDark ? AppColors.gray500 : AppColors.gray400, size: 20),
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


import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final List<Map<String, String>> _accounts = [
    {
      'bank': 'KBZ Bank',
      'accountNo': '092 103 992 0184 01',
      'type': 'Saving Account',
      'logo': 'KBZ',
      'color': '0xFF003366',
    },
    {
      'bank': 'AYA Bank',
      'accountNo': '200 482 910 4912 02',
      'type': 'Special Account',
      'logo': 'AYA',
      'color': '0xFFC00000',
    },
  ];

  void _addAccount() {
    final controller = TextEditingController(text: 'CB Bank');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Bank Account'.tr('ဘဏ်အကောင့် ထည့်မည်'), style: TextStyle(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Bank Name (KBZ, AYA, CB, Yoma)'.tr('ဘဏ်အမည် (KBZ, AYA, CB, Yoma)')),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'.tr('မလုပ်တော့ပါ'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _accounts.add({
                  'bank': controller.text,
                  'accountNo': '884 102 948 2011 09',
                  'type': 'Connected Account',
                  'logo': 'BANK',
                  'color': '0xFF171717',
                });
              });
              HimoToast.show(context, 'Bank account linked successfully'.tr('ဘဏ်အကောင့် ချိတ်ဆက်မှု အောင်မြင်ပါသည်'));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.black),
            child: Text('Add'.tr('ထည့်မည်')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HimoAppBar(
        title: 'Bank Accounts'.tr('ချိတ်ဆက်ထားသော ဘဏ်များ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 24),
            onPressed: _addAccount,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _accounts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final acc = _accounts[index];
            return HimoCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(int.parse(acc['color']!)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        acc['logo']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(acc['bank']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(acc['accountNo']!, style: const TextStyle(fontSize: 13, color: AppColors.gray500, fontFamily: 'monospace')),
                        const SizedBox(height: 2),
                        Text(acc['type']!, style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

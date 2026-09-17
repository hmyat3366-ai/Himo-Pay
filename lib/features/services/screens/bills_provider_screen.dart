import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class BillsProviderScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const BillsProviderScreen({super.key, this.data});

  @override
  State<BillsProviderScreen> createState() => _BillsProviderScreenState();
}

class _BillsProviderScreenState extends State<BillsProviderScreen> {
  final HimoRepository _repo = HimoRepository();
  final TextEditingController _accountController = TextEditingController(text: '9481-2210-883');
  bool _billLoaded = true;
  final int _billAmount = 28500;
  final String _customerName = 'U Tin Maung';
  final String _billPeriod = 'August 2026';

  void _payBill() {
    if (_repo.balance < _billAmount) {
      HimoToast.show(context, 'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    final cat = widget.data?['category'] ?? 'Electricity Bill';
    final provider = widget.data?['provider'] ?? 'YESC Yangon';

    _repo.deductBalance(_billAmount);
    _repo.addPoints((_billAmount / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-BL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '$cat Payment',
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: _billAmount,
        type: TransactionType.outMoney,
        category: 'Utility Bill'.tr('အသုံးစရိတ်ဘေလ်'),
      ),
    );

    Navigator.of(context).pushReplacementNamed(
      '/bills-success',
      arguments: {
        'category': cat,
        'provider': provider,
        'account': _accountController.text,
        'amount': _billAmount,
        'customer': _customerName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.data?['category'] ?? 'Electricity Bill';
    final provider = widget.data?['provider'] ?? 'YESC (Yangon Electricity Supply Corp)';

    return Scaffold(
      appBar: HimoAppBar(title: cat),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            HimoCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.receipt_long_rounded, color: AppColors.primaryGold, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(provider, style: const TextStyle(fontSize: 12, color: AppColors.gray500), maxLines: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('ACCOUNT / METER NUMBER'.tr('မီတာ / အကောင့်နံပါတ်'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: TextField(
                controller: _accountController,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Enter Account or Meter ID'.tr('အကောင့် သို့မဟုတ် မီတာ ID ရိုက်ထည့်ပါ'),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search_rounded, color: AppColors.primaryGold),
                    onPressed: () {
                      setState(() => _billLoaded = true);
                      HimoToast.show(context, 'Bill record retrieved'.tr('ဘေလ် အချက်အလက် ရှာတွေ့ပါသည်'));
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (_billLoaded) ...[
              HimoCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OUTSTANDING INVOICE'.tr('ကျသင့်ငွေ ပြေစာ'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                    const SizedBox(height: 14),
                    _buildRow(context, 'Account Name'.tr('အကောင့်ပိုင်ရှင် အမည်'), _customerName),
                    const Divider(height: 20),
                    _buildRow(context, 'Billing Cycle'.tr('ကျသင့်သည့် ကာလ'), _billPeriod),
                    const Divider(height: 20),
                    _buildRow(context, 'Due Date'.tr('နောက်ဆုံးပေးရမည့်ရက်'), '28 Sep 2026', valueColor: AppColors.error),
                    const Divider(height: 20),
                    _buildRow(
                      context,
                      'Total Payable'.tr('စုစုပေါင်း ကျသင့်ငွေ'),
                      CurrencyFormatter.formatMMK(_billAmount),
                      valueColor: AppColors.primaryDark,
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              HimoCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryGold, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wallet Balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ'), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                          Text(CurrencyFormatter.formatMMK(_repo.balance), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Text('No Fee'.tr('ဝန်ဆောင်ခ မရှိ'), style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              HimoButton(
                text: 'Pay Bill '.tr('ဘေလ်ပေးချေမည် ') + CurrencyFormatter.formatMMK(_billAmount),
                onPressed: _payBill,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {Color? valueColor, bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

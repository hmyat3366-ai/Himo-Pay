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

class ScanPaymentDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const ScanPaymentDetailScreen({super.key, this.data});

  @override
  State<ScanPaymentDetailScreen> createState() => _ScanPaymentDetailScreenState();
}

class _ScanPaymentDetailScreenState extends State<ScanPaymentDetailScreen> {
  final HimoRepository _repo = HimoRepository();
  bool _usePromo = false;
  int _discount = 0;

  void _completePayment(int amount, String merchant, String branch) {
    final finalAmount = amount - _discount;
    if (_repo.balance < finalAmount) {
      HimoToast.show(context, 'Insufficient wallet balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    _repo.deductBalance(finalAmount);
    _repo.addPoints((finalAmount / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-QR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: 'Paid to $merchant',
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: finalAmount,
        type: TransactionType.outMoney,
        category: 'Merchant Pay'.tr('ဆိုင်ရှင်းငွေ'),
      ),
    );

    Navigator.of(context).pushReplacementNamed(
      '/scan-payment-success',
      arguments: {
        'merchant': merchant,
        'branch': branch,
        'amount': finalAmount,
        'originalAmount': amount,
        'discount': _discount,
        'points': (finalAmount / 500).round(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final merchant = widget.data?['merchantName'] ?? 'Rangoon Tea House';
    final branch = widget.data?['branch'] ?? 'Downtown Branch • Table #04';
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 18500;
    final points = (amount / 500).round();

    return Scaffold(
      appBar: HimoAppBar(title: 'Merchant Payment'.tr('ဆိုင်သို့ ငွေပေးချေမည်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Merchant info card
            HimoCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        merchant.substring(0, 3).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryGold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VERIFIED MERCHANT'.tr('အသိအမှတ်ပြု ဆိုင်'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                        const SizedBox(height: 2),
                        Text(merchant, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(branch, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Official'.tr('တရားဝင်'), style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Amount Card
            HimoCard(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Text('Total Bill Amount'.tr('ကျသင့်ငွေ စုစုပေါင်း'), style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatMMK(amount - _discount),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Earns +$points Himo Points'.tr('Himo ပွိုင့် +$points ရရှိမည်'),
                      style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Voucher Discount Tile
            HimoCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_num_outlined, color: AppColors.primaryGold, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Merchant Voucher'.tr('ဆိုင်သုံး ကူပွန်'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('10% OFF Dining Promo'.tr('အစားအသောက် ၁၀% လျှော့ဈေး'), style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _usePromo,
                    activeColor: AppColors.primaryGold,
                    onChanged: (val) {
                      setState(() {
                        _usePromo = val;
                        _discount = val ? (amount * 0.1).round() : 0;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Payment method tile
            HimoCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method'.tr('ပေးချေသည့် နည်းလမ်း'), style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                      Text('Himo Wallet Balance'.tr('Himo ပိုက်ဆံအိတ် လက်ကျန်ငွေ'), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Available Balance'.tr('သုံးစွဲနိုင်သော လက်ကျန်ငွေ'), style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                      Text(
                        CurrencyFormatter.formatMMK(_repo.balance),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            HimoButton(
              text: 'Confirm & Pay '.tr('အတည်ပြုပြီး ပေးချေမည် ') + CurrencyFormatter.formatMMK(amount - _discount),
              onPressed: () => _completePayment(amount, merchant, branch),
            ),
          ],
        ),
      ),
    );
  }
}

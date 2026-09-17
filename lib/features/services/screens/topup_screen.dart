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

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final HimoRepository _repo = HimoRepository();
  final TextEditingController _phoneController = TextEditingController(text: '09798123456');

  String _selectedOperator = 'ATOM';
  int _selectedAmount = 5000;
  int _selectedTabIndex = 0; // 0: Airtime, 1: Data Packs

  final List<String> _operators = ['MPT', 'ATOM', 'Ooredoo', 'Mytel'];
  final List<int> _airtimePacks = [1000, 3000, 5000, 10000, 20000, 50000];

  final List<Map<String, dynamic>> _dataPacks = [
    {'name': '1.5 GB Data Pack', 'name_my': '1.5 GB ဒေတာပက်ကေ့ချ်', 'validity': '3 Days Validity', 'validity_my': '၃ ရက် သက်တမ်း', 'amount': 1800},
    {'name': '3.0 GB Data Pack', 'name_my': '3.0 GB ဒေတာပက်ကေ့ချ်', 'validity': '7 Days Validity', 'validity_my': '၇ ရက် သက်တမ်း', 'amount': 3500},
    {'name': '8.0 GB Unlimited Social', 'name_my': '8.0 GB လူမှုကွန်ရက် သုံးမကုန်', 'validity': '30 Days Validity', 'validity_my': 'ရက် ၃၀ သက်တမ်း', 'amount': 7900},
    {'name': '15 GB Super Stream', 'name_my': '15 GB ရုပ်သံကြည့်ရှုရန်', 'validity': '30 Days Validity', 'validity_my': 'ရက် ၃၀ သက်တမ်း', 'amount': 14900},
  ];

  void _confirmTopUp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      HimoToast.show(context, 'Please enter a valid phone number'.tr('ကျေးဇူးပြု၍ ဖုန်းနံပါတ် မှန်ကန်စွာ ရိုက်ထည့်ပါ'), isError: true);
      return;
    }

    final cost = _selectedTabIndex == 0 ? _selectedAmount : _dataPacks[0]['amount'] as int;
    if (_repo.balance < cost) {
      HimoToast.show(context, 'Insufficient wallet balance'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    _repo.deductBalance(cost);
    _repo.addPoints((cost / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-TU-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '$_selectedOperator Top Up $phone',
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: cost,
        type: TransactionType.outMoney,
        category: 'Top Up'.tr('ဖုန်းငွေဖြည့်'),
      ),
    );

    Navigator.of(context).pushReplacementNamed(
      '/topup-success',
      arguments: {
        'operator': _selectedOperator,
        'phone': phone,
        'amount': cost,
        'type': _selectedTabIndex == 0 ? 'Airtime'.tr('ဖုန်းငွေဖြည့်') : 'Data Pack'.tr('ဒေတာပက်ကေ့ချ်'),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Mobile Top Up'.tr('ဖုန်းငွေဖြည့်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Operator filter chips
            Text('SELECT OPERATOR'.tr('အော်ပရေတာ ရွေးချယ်ပါ'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
            const SizedBox(height: 8),
            Row(
              children: _operators.map((op) {
                final isSelected = _selectedOperator == op;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedOperator = op),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGold
                              : (isDark ? AppColors.surfaceElevatedDark : AppColors.gray100),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGold : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          op,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Phone Number Input
            Text('MOBILE NUMBER'.tr('ဖုန်းနံပါတ်'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text('🇲🇲 +95', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        hintText: '9xxxxxxxxx',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tabs: Airtime vs Data
            Row(
              children: [
                _buildTabPill('Airtime Credit'.tr('ဖုန်းလက်ကျန်ငွေ'), 0, isDark),
                const SizedBox(width: 10),
                _buildTabPill('Data Packs'.tr('ဒေတာ ပက်ကေ့ချ်'), 1, isDark),
              ],
            ),
            const SizedBox(height: 16),
            if (_selectedTabIndex == 0) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _airtimePacks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, i) {
                  final amt = _airtimePacks[i];
                  final isSelected = _selectedAmount == amt;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAmount = amt),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGold.withOpacity(0.15)
                            : (isDark ? AppColors.surfaceElevatedDark : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.borderDark : AppColors.gray200),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            CurrencyFormatter.formatNumberOnly(amt),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.primaryDark : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text('MMK', style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              Column(
                children: _dataPacks.map((pack) {
                  final name = (pack['name'] as String).tr(pack['name_my'] as String);
                  final validity = (pack['validity'] as String).tr(pack['validity_my'] as String);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HimoCard(
                      onTap: () {
                        setState(() => _selectedAmount = pack['amount'] as int);
                      },
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.wifi_rounded, color: AppColors.primaryGold, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(validity, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.formatMMK(pack['amount'] as int),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            // Balance row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available Balance'.tr('သုံးစွဲနိုင်သော လက်ကျန်ငွေ'), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                Text(
                  CurrencyFormatter.formatMMK(_repo.balance),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20),
            HimoButton(
              text: 'Top Up '.tr('ငွေဖြည့်မည် ') + CurrencyFormatter.formatMMK(_selectedAmount),
              onPressed: _confirmTopUp,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String title, int idx, bool isDark) {
    final isSelected = _selectedTabIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

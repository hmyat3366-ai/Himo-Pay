import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_amount_keypad.dart';
import '../../../core/widgets/himo_physical_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';

class CashoutAmountScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const CashoutAmountScreen({super.key, this.data});

  @override
  State<CashoutAmountScreen> createState() => _CashoutAmountScreenState();
}

class _CashoutAmountScreenState extends State<CashoutAmountScreen> {
  final TextEditingController _amountController = TextEditingController(text: '50,000');
  final HimoRepository _repo = HimoRepository();
  int _selectedPreset = 50000;

  final List<int> _presets = [10000, 30000, 50000, 100000, 200000, 500000];

  void _onDigitPress(String digit) {
    setState(() {
      String raw = _amountController.text.replaceAll(',', '').trim();
      if (raw == '0' || raw.isEmpty) {
        raw = digit;
      } else {
        if (digit == '00') {
          if (raw.length <= 7) raw += '00';
        } else {
          if (raw.length <= 8) raw += digit;
        }
      }
      final parsed = int.tryParse(raw) ?? 0;
      _selectedPreset = parsed;
      _amountController.text = CurrencyFormatter.formatMMK(parsed, includeSymbol: false);
    });
  }

  void _onDelete() {
    setState(() {
      String raw = _amountController.text.replaceAll(',', '').trim();
      if (raw.isNotEmpty) {
        raw = raw.substring(0, raw.length - 1);
      }
      if (raw.isEmpty || raw == '0') {
        _amountController.text = '0';
        _selectedPreset = 0;
      } else {
        final parsed = int.tryParse(raw) ?? 0;
        _selectedPreset = parsed;
        _amountController.text = CurrencyFormatter.formatMMK(parsed, includeSymbol: false);
      }
    });
  }

  void _onClear() {
    setState(() {
      _amountController.text = '0';
      _selectedPreset = 0;
    });
  }

  int get _currentAmount {
    return CurrencyFormatter.parseAmount(_amountController.text);
  }

  double get _fee {
    final feeType = widget.data?['feeType'];
    if (feeType == 'fixed') {
      return ((widget.data?['fixedFee'] as num?)?.toDouble()) ?? 500.0;
    }
    return (_currentAmount * 0.002).clamp(100.0, 5000.0);
  }

  double get _totalDeduction {
    return _currentAmount + _fee;
  }

  bool get _isInsufficient {
    return _totalDeduction > _repo.balance;
  }

  void _proceed() {
    final amt = _currentAmount.toInt();
    if (amt < 1000) {
      HimoToast.show(context, 'Minimum cash out is 1,000 MMK'.tr('အနည်းဆုံး ငွေထုတ်ပမာဏမှာ ၁,၀၀၀ ကျပ်ဖြစ်ပါသည်'), isError: true);
      return;
    }

    final total = _totalDeduction.toInt();
    if (_repo.balance < total) {
      HimoToast.show(context, 'Insufficient balance including fee'.tr('လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    final method = widget.data?['method']?.toString() ?? 'Withdraw to Bank';
    final destination = widget.data?['destination']?.toString() ?? method;
    final type = widget.data?['type']?.toString() ?? 'bank';

    Navigator.of(context).pushNamed(
      '/cashout-security',
      arguments: {
        'method': method,
        'destination': destination,
        'type': type,
        'amount': amt,
        'fee': _fee.toInt(),
        'total': total,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final method = widget.data?['method']?.toString() ?? 'Withdraw to Bank';
    final destination = widget.data?['destination']?.toString() ?? method;
    final type = widget.data?['type']?.toString() ?? 'bank';

    return Scaffold(
      appBar: HimoAppBar(title: 'Cash Out Amount'.tr('ငွေထုတ်ယူမည့် ပမာဏ')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destination: Realistic Titanium Physical Card
              HimoPhysicalCard(
                cardHolder: 'ROBIN HOLESINSKY',
                cardNumber: type == 'bank'
                    ? (widget.data?['account']?.toString() ?? destination)
                    : (type == 'atm' ? 'ATM CARDLESS TOKEN' : 'AGENT STORE PICKUP'),
                bankName: destination,
                cardType: 'VISA',
                tier: 'Platinum',
                balance: _repo.balance,
                balanceLabel: 'Wallet Balance'.tr('အသုံးပြုနိုင်သော လက်ကျန်ငွေ'),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.primaryGold),
                    const SizedBox(width: 8),
                    Text(
                      'Available: ${CurrencyFormatter.formatMMK(_repo.balance)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Withdrawal Amount (MMK)'.tr('ထုတ်ယူမည့် ငွေပမာဏ (ကျပ်)'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isInsufficient ? AppColors.error : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: TextField(
                  controller: _amountController,
                  readOnly: true,
                  showCursor: true,
                  cursorColor: AppColors.primaryGold,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    prefixText: 'Ks ',
                    prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primaryGold),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _presets.map((preset) {
                  final isSelected = _selectedPreset == preset;
                  return ChoiceChip(
                    label: Text(CurrencyFormatter.formatMMK(preset)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPreset = preset;
                          _amountController.text = CurrencyFormatter.formatNumberOnly(preset);
                        });
                      }
                    },
                    selectedColor: AppColors.primaryGold,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.gray200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Cash Out Fee (0.2%)'.tr('ငွေထုတ် ဝန်ဆောင်ခ (၀.၂%)'), style: TextStyle(fontSize: 13, color: AppColors.gray500)),
                        Text(CurrencyFormatter.formatMMK(_fee.toInt()), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Deduction'.tr('စုစုပေါင်း နုတ်ယူငွေ'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text(
                          CurrencyFormatter.formatMMK(_totalDeduction.toInt()),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              HimoAmountKeypad(
                onKeyPress: _onDigitPress,
                onDelete: _onDelete,
                onClear: _onClear,
                leftActionText: '00',
              ),
              const SizedBox(height: 16),
              HimoButton(
                text: 'Confirm Cash Out'.tr('ငွေထုတ်ယူမှု အတည်ပြုမည်'),
                onPressed: _proceed,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

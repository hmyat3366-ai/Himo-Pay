import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_amount_keypad.dart';
import '../../../core/widgets/himo_physical_card.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class CashinAmountScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const CashinAmountScreen({super.key, this.data});

  @override
  State<CashinAmountScreen> createState() => _CashinAmountScreenState();
}

class _CashinAmountScreenState extends State<CashinAmountScreen> {
  final TextEditingController _amountController = TextEditingController(text: '50,000');
  final HimoRepository _repo = HimoRepository();
  final List<int> _quickPresets = [10000, 30000, 50000, 100000, 200000, 500000];

  bool _isAuthorizing = false;
  String _authorizingStep = 'Connecting to payment gateway...';

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
      } else {
        final parsed = int.tryParse(raw) ?? 0;
        _amountController.text = CurrencyFormatter.formatMMK(parsed, includeSymbol: false);
      }
    });
  }

  void _onClear() {
    setState(() {
      _amountController.text = '0';
    });
  }

  void _selectPreset(int preset) {
    setState(() {
      _amountController.text = CurrencyFormatter.formatMMK(preset, includeSymbol: false);
    });
  }

  void _proceed() async {
    final amt = CurrencyFormatter.parseAmount(_amountController.text);
    if (amt < 1000) {
      HimoToast.show(context, 'Minimum deposit is 1,000 MMK'.tr('အနည်းဆုံး ငွေသွင်းပမာဏမှာ ၁,၀၀၀ ကျပ်ဖြစ်ပါသည်'), isError: true);
      return;
    }
    if (amt > 5000000) {
      HimoToast.show(context, 'Maximum single deposit limit is 5,000,000 MMK'.tr('တစ်ကြိမ် အများဆုံး ငွေသွင်းနိုင်သော ပမာဏမှာ ၅,၀၀၀,၀၀၀ ကျပ်ဖြစ်ပါသည်'), isError: true);
      return;
    }

    final method = widget.data?['method']?.toString() ?? 'KBZ Bank Direct Pay';
    final account = widget.data?['account']?.toString() ?? 'Primary Account';

    // Show simulated bank authorization HUD
    setState(() {
      _isAuthorizing = true;
      _authorizingStep = '${'Connecting to '.tr('ချိတ်ဆက်နေပါသည်: ')}$method...';
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _authorizingStep = 'Authorizing direct deposit token...'.tr('ငွေသွင်းခွင့် အထောက်အထား စစ်ဆေးနေပါသည်...');
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy, hh:mm a').format(now);
    final txId = _repo.generateTxId('CI');

    // Deposit funds and reward points
    _repo.addBalance(amt);
    _repo.addPoints(25);

    _repo.addTransaction(
      TransactionModel(
        id: txId,
        title: 'Deposit from $method',
        date: formattedDate,
        amount: amt,
        type: TransactionType.inMoney,
        category: 'Top Up',
        recipientOrMethod: method,
        recipientAccount: account,
        fee: 0,
        note: 'Cash In Deposit',
        referenceNumber: 'DEP-${txId.replaceAll('HM-', '')}',
        timestamp: now,
      ),
    );

    final successData = {
      'method': method,
      'account': account,
      'amount': amt,
      'id': txId,
      'date': formattedDate,
      'pointsEarned': 25,
      'remainingBalance': _repo.balance,
      'fee': 0,
    };

    Navigator.of(context).pushReplacementNamed(
      '/cashin-success',
      arguments: successData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final method = widget.data?['method']?.toString() ?? 'KBZ Bank Direct Pay';
    final account = widget.data?['account']?.toString();

    return Scaffold(
      appBar: HimoAppBar(title: 'Deposit Amount'.tr('ငွေသွင်းပမာဏ')),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source Method Box: Realistic Titanium Physical Card
                  HimoPhysicalCard(
                    cardHolder: 'ROBIN HOLESINSKY',
                    cardNumber: account ?? 'AYA •••• 8201',
                    bankName: method,
                    cardType: 'VISA',
                    tier: 'Platinum',
                    balance: 3850000,
                    balanceLabel: 'Card Balance'.tr('ကတ်လက်ကျန်ငွေ'),
                  ),
                  const SizedBox(height: 16),

                  Text('Enter Deposit Amount (MMK)'.tr('သွင်းမည့် ငွေပမာဏ ရိုက်ထည့်ပါ (ကျပ်)'), style: const TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : Colors.white,
                      borderRadius: AppRadius.cardBorder,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Text('MMK', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            readOnly: true,
                            showCursor: true,
                            cursorColor: AppColors.primary,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.gray900,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text('Min: 1,000 MMK • Max: 5,000,000 MMK • Fee: 0 MMK (Free)'.tr('အနည်းဆုံး: ၁,၀၀၀ ကျပ် • ဝန်ဆောင်ခ: အခမဲ့'), style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                  const SizedBox(height: 12),

                  // Quick amount presets
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickPresets.map((preset) {
                      final label = CurrencyFormatter.formatMMK(preset, includeSymbol: false);
                      final isSelected = _amountController.text == label;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        onSelected: (_) => _selectPreset(preset),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppColors.primaryDark : (isDark ? Colors.white : AppColors.gray800),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Built-in Fintech Number Keyboard
                  HimoAmountKeypad(
                    onKeyPress: _onDigitPress,
                    onDelete: _onDelete,
                    onClear: _onClear,
                    leftActionText: '00',
                  ),
                  const SizedBox(height: 14),

                  HimoButton(
                    text: 'Confirm Cash In'.tr('ငွေသွင်းမှုကို အတည်ပြုမည်'),
                    onPressed: _proceed,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            if (_isAuthorizing)
              Container(
                color: (isDark ? Colors.black : Colors.white).withOpacity(0.85),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _authorizingStep,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


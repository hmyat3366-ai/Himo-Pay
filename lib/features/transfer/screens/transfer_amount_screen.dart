import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_amount_keypad.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';

class TransferAmountScreen extends StatefulWidget {
  final Map<String, dynamic>? recipient;

  const TransferAmountScreen({super.key, this.recipient});

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  final TextEditingController _amountController = TextEditingController(text: '20,000');
  final TextEditingController _noteController = TextEditingController();
  final HimoRepository _repo = HimoRepository();

  final List<int> _quickAmounts = [10000, 20000, 50000, 100000];
  final List<String> _quickNotes = ['Gift 🎁', 'Food 🍲', 'Allowance 💵', 'Rent 🏠', 'Payment 💼'];
  String? _selectedNoteChip;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int get _enteredAmount {
    return CurrencyFormatter.parseAmount(_amountController.text);
  }

  bool get _isInsufficient {
    return _enteredAmount > _repo.balance;
  }

  void _selectQuickAmount(int amt) {
    setState(() {
      _amountController.text = CurrencyFormatter.formatMMK(amt, includeSymbol: false);
    });
  }

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

  void _proceedToReview() {
    final amt = _enteredAmount;
    if (amt < 1000) {
      HimoToast.show(context, 'Minimum transfer is 1,000 MMK'.tr('အနည်းဆုံး ငွေလွှဲပမာဏမှာ ၁,၀၀၀ ကျပ်ဖြစ်ပါသည်'), isError: true);
      return;
    }

    if (amt > _repo.balance) {
      HimoToast.show(context, 'Insufficient wallet balance'.tr('လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    final name = widget.recipient?['name']?.toString() ?? 'Daw Thida';
    final phone = widget.recipient?['phone']?.toString() ?? '09 951 884 102';
    final type = widget.recipient?['type']?.toString() ?? 'wallet';
    final bank = widget.recipient?['bank']?.toString();
    final accountNumber = widget.recipient?['accountNumber']?.toString();

    final note = _noteController.text.trim().isNotEmpty
        ? _noteController.text.trim()
        : (_selectedNoteChip ?? 'Transfer');

    Navigator.of(context).pushNamed(
      '/transfer-review',
      arguments: {
        'name': name,
        'phone': phone,
        'amount': amt,
        'note': note,
        'type': type,
        'bank': bank,
        'accountNumber': accountNumber,
        'fee': 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.recipient?['name']?.toString() ?? 'Daw Thida';
    final phone = widget.recipient?['phone']?.toString() ?? '09 951 884 102';
    final isBank = widget.recipient?['type'] == 'bank';
    final wallet = _repo.getWallet();

    return Scaffold(
      appBar: HimoAppBar(title: 'Transfer Amount'.tr('ငွေလွှဲပမာဏ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient summary card
              HimoCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: isBank
                          ? const Color(0xFF003882).withOpacity(0.18)
                          : AppColors.primary.withOpacity(0.18),
                      child: isBank
                          ? const Icon(Icons.account_balance, color: Color(0xFF003882), size: 22)
                          : Text(
                              name.isNotEmpty ? name.substring(0, 1) : 'H',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark, fontSize: 16),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, size: 14, color: AppColors.primary),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(phone, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isBank ? 'Bank Transfer'.tr('ဘဏ်ငွေလွှဲ') : 'Himo Wallet'.tr('ပိုက်ဆံအိတ်'),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('Enter Amount (MMK)'.tr('ငွေပမာဏ ရိုက်ထည့်ပါ (ကျပ်)'), style: const TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              // Amount Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceCardDark : Colors.white,
                  borderRadius: AppRadius.cardBorder,
                  border: Border.all(
                    color: _isInsufficient ? AppColors.error : AppColors.primary,
                    width: 1.5,
                  ),
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
                          color: _isInsufficient ? AppColors.error : (isDark ? Colors.white : AppColors.gray900),
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
              const SizedBox(height: 6),

              // Available Balance hint / Insufficient warning
              if (_isInsufficient)
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${'Insufficient balance. Available: '.tr('လက်ကျန်ငွေ မလုံလောက်ပါ။ လက်ကျန်: ')}${wallet.formattedBalance}',
                      style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              else
                Text(
                  '${'Available Wallet Balance: '.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ: ')}${wallet.formattedBalance}',
                  style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                ),
              const SizedBox(height: 12),

              // Quick Amount Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _quickAmounts.map((amt) {
                  final label = CurrencyFormatter.formatMMK(amt, includeSymbol: false);
                  final isSelected = _amountController.text == label;
                  return InkWell(
                    onTap: () => _selectQuickAmount(amt),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : (isDark ? AppColors.surfaceCardDark : Colors.white),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.gray200),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.gray900),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Note / Remarks Input
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceCardDark : Colors.white,
                  borderRadius: AppRadius.cardBorder,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.gray200),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.notes_rounded, size: 18, color: AppColors.gray400),
                    hintText: 'Add note or remark (Optional)'.tr('မှတ်ချက် ရေးရန် (စိတ်ကြိုက်)'),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    filled: false,
                    hintStyle: const TextStyle(fontSize: 12, color: AppColors.gray400),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Quick note chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickNotes.map((note) {
                    final isSelected = _selectedNoteChip == note;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(note, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primaryDark : null)),
                        backgroundColor: isSelected ? AppColors.primary.withOpacity(0.15) : null,
                        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.gray300, width: 1),
                        onPressed: () {
                          setState(() {
                            _selectedNoteChip = isSelected ? null : note;
                            _noteController.text = _selectedNoteChip ?? '';
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
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
                text: 'Review Transfer'.tr('ငွေလွှဲအချက်အလက် စစ်ဆေးမည်'),
                onPressed: _proceedToReview,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


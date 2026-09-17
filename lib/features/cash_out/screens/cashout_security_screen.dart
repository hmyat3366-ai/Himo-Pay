import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_biometric_modal.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class CashoutSecurityScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const CashoutSecurityScreen({super.key, this.data});

  @override
  State<CashoutSecurityScreen> createState() => _CashoutSecurityScreenState();
}

class _CashoutSecurityScreenState extends State<CashoutSecurityScreen> {
  final List<int> _pin = [];
  final HimoRepository _repo = HimoRepository();
  bool _isProcessing = false;
  String _processingMessage = 'Authenticating security credentials...';

  void _onDigit(int digit) {
    if (_isProcessing) return;
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        _completeCashout();
      }
    }
  }

  void _onDelete() {
    if (_isProcessing) return;
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  Future<void> _onBiometric() async {
    if (_isProcessing) return;
    final total = (widget.data?['total'] as num?)?.toInt() ?? 50000;
    final verified = await HimoBiometricModal.show(
      context,
      title: 'Authorize Cash Out'.tr('ငွေထုတ်ယူမှုကို အတည်ပြုပါ'),
      subtitle: '${'Authenticate with fingerprint to withdraw '.tr('ငွေထုတ်ယူရန် လက်ဗွေဖြင့် အတည်ပြုပါ: ')}${CurrencyFormatter.formatMMK(total)}',
    );

    if (verified && mounted) {
      _completeCashout();
    }
  }

  void _completeCashout() async {
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Validating withdrawal security...'.tr('ငွေထုတ်ယူမှု လုံခြုံရေး စစ်ဆေးနေပါသည်...');
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _processingMessage = 'Transmitting settlement to banking network...'.tr('ဘဏ်စနစ်သို့ ငွေလွှဲပြောင်းမှု ပေးပို့နေပါသည်...');
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final method = widget.data?['method']?.toString() ?? 'Withdraw to Bank';
    final destination = widget.data?['destination']?.toString() ?? method;
    final type = widget.data?['type']?.toString() ?? 'bank';
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 50000;
    final fee = (widget.data?['fee'] as num?)?.toInt() ?? 100;
    final total = (widget.data?['total'] as num?)?.toInt() ?? (amount + fee);

    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy, hh:mm a').format(now);
    final txId = _repo.generateTxId('CO');

    // Generate ATM 6-digit cashout code if ATM
    final random = Random();
    final atmOtp = '${100 + random.nextInt(900)} ${100 + random.nextInt(900)}';
    final agentToken = 'AGT-${100000 + random.nextInt(900000)}';

    // Deduct balance
    _repo.deductBalance(total);

    _repo.addTransaction(
      TransactionModel(
        id: txId,
        title: 'Cash Out ($destination)',
        date: formattedDate,
        amount: amount,
        type: TransactionType.outMoney,
        category: 'Cash Out',
        recipientOrMethod: destination,
        recipientAccount: type == 'atm' ? 'ATM Network' : (type == 'agent' ? 'Agent Counter' : destination),
        fee: fee,
        note: type == 'atm' ? 'ATM Cardless Withdrawal' : 'Cash Out Withdrawal',
        referenceNumber: 'WD-${txId.replaceAll('HM-', '')}',
        timestamp: now,
      ),
    );

    final successData = {
      'method': method,
      'destination': destination,
      'type': type,
      'amount': amount,
      'fee': fee,
      'total': total,
      'id': txId,
      'date': formattedDate,
      'atmOtp': atmOtp,
      'agentToken': agentToken,
      'remainingBalance': _repo.balance,
    };

    Navigator.of(context).pushReplacementNamed(
      '/cashout-success',
      arguments: successData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = (widget.data?['total'] as num?)?.toInt() ?? 50000;
    final destination = widget.data?['destination']?.toString() ?? 'Cash Out';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Enter PIN'.tr('PIN ရိုက်ထည့်ပါ')),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'Authorize Cash Out'.tr('ငွေထုတ်ယူမှုကို အတည်ပြုပါ'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.4),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${'Enter 6-digit payment PIN to withdraw '.tr('ငွေထုတ်ယူရန် PIN ကုဒ် ရိုက်ထည့်ပါ: ')}${CurrencyFormatter.formatMMK(total)} ($destination)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppColors.gray500),
                  ),
                ),
                const Spacer(),

                HimoKeypad(
                  pinLength: _pin.length,
                  maxPinLength: 6,
                  onDigitPress: _onDigit,
                  onDeletePress: _onDelete,
                  showBiometric: true,
                  onBiometricPress: _onBiometric,
                ),
                const SizedBox(height: AppSpacing.hero),
              ],
            ),

            if (_isProcessing)
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
                          child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primaryGold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _processingMessage,
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

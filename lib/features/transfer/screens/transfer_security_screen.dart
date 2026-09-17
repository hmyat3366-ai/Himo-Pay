import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_biometric_modal.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class TransferSecurityScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const TransferSecurityScreen({super.key, this.data});

  @override
  State<TransferSecurityScreen> createState() => _TransferSecurityScreenState();
}

class _TransferSecurityScreenState extends State<TransferSecurityScreen> {
  final List<int> _pin = [];
  final HimoRepository _repo = HimoRepository();
  bool _isProcessing = false;
  String _processingMessage = 'Authenticating security token...';

  void _onDigit(int digit) {
    if (_isProcessing) return;
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        _completeTransfer();
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
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 20000;
    final verified = await HimoBiometricModal.show(
      context,
      title: 'Authorize Payment'.tr('ငွေပေးချေမှုကို အတည်ပြုပါ'),
      subtitle: '${'Authenticate with fingerprint to transfer '.tr('ငွေလွှဲရန် လက်ဗွေဖြင့် အတည်ပြုပါ: ')}${CurrencyFormatter.formatMMK(amount)}',
    );

    if (verified && mounted) {
      _completeTransfer();
    }
  }

  void _completeTransfer() async {
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Verifying security credentials...'.tr('လုံခြုံရေး အထောက်အထား စစ်ဆေးနေပါသည်...');
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _processingMessage = 'Transferring funds via secure ledger...'.tr('ငွေပေးချေမှုကို လုံခြုံစွာ ဆောင်ရွက်နေပါသည်...');
    });

    await Future.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    final name = widget.data?['name']?.toString() ?? 'Daw Thida';
    final phone = widget.data?['phone']?.toString() ?? '09 951 884 102';
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 20000;
    final note = widget.data?['note']?.toString() ?? 'Transfer';
    final isBank = widget.data?['type'] == 'bank';
    final bank = widget.data?['bank']?.toString();

    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM yyyy, hh:mm a').format(now);
    final txId = _repo.generateTxId('TR');

    // Deduct balance and reward points
    _repo.deductBalance(amount);
    _repo.addPoints(20);

    _repo.addTransaction(
      TransactionModel(
        id: txId,
        title: isBank ? 'Transfer to $bank' : 'Transfer to $name',
        date: formattedDate,
        amount: amount,
        type: TransactionType.outMoney,
        category: isBank ? 'Bank Transfer' : 'P2P Transfer',
        recipientOrMethod: name,
        recipientAccount: phone,
        fee: 0,
        note: note,
        referenceNumber: 'REF-${txId.replaceAll('HM-', '')}',
        timestamp: now,
      ),
    );

    final successData = {
      'id': txId,
      'name': name,
      'phone': phone,
      'amount': amount,
      'note': note,
      'date': formattedDate,
      'type': widget.data?['type'],
      'bank': bank,
      'remainingBalance': _repo.balance,
      'fee': 0,
    };

    Navigator.of(context).pushReplacementNamed(
      '/transfer-success',
      arguments: successData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 20000;
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
                  'Authorize Payment'.tr('ငွေပေးချေမှုကို အတည်ပြုပါ'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'Enter 6-digit payment PIN to transfer '.tr('ငွေလွှဲရန် ဂဏန်း ၆ လုံး PIN ကုဒ် ရိုက်ထည့်ပါ: ')}${CurrencyFormatter.formatMMK(amount)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.gray500),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceCardDark : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              _processingMessage,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


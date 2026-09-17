import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_confetti.dart';
import '../../../core/utils/currency_formatter.dart';

class CashoutSuccessScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const CashoutSuccessScreen({super.key, this.data});

  @override
  State<CashoutSuccessScreen> createState() => _CashoutSuccessScreenState();
}

class _CashoutSuccessScreenState extends State<CashoutSuccessScreen> {
  int _secondsLeft = 900; // 15 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft > 0) {
        if (mounted) setState(() => _secondsLeft--);
      } else {
        t.cancel();
      }
    });
  }

  String get _formattedCountdown {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = widget.data?['type']?.toString() ?? 'bank';
    final method = widget.data?['method']?.toString() ?? 'Bank Account';
    final destination = widget.data?['destination']?.toString() ?? method;
    final amount = (widget.data?['amount'] as num?)?.toInt() ?? 50000;
    final fee = (widget.data?['fee'] as num?)?.toInt() ?? 100;
    final total = (widget.data?['total'] as num?)?.toInt() ?? (amount + fee);
    final txId = widget.data?['id']?.toString() ?? 'HM-CO-883901';
    final atmOtp = widget.data?['atmOtp']?.toString() ?? '592 108';
    final agentToken = widget.data?['agentToken']?.toString() ?? 'AGT-849201';
    final remainingBalance = (widget.data?['remainingBalance'] as num?)?.toInt();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGold.withOpacity(0.15),
                  border: Border.all(color: AppColors.primaryGold, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.primaryGold, size: 44),
              ),
              const SizedBox(height: 16),
              Text(
                type == 'atm'
                    ? 'ATM Code Generated!'.tr('ATM ကုဒ် ရရှိပါပြီ!')
                    : (type == 'agent' ? 'Agent Token Created!'.tr('ငွေထုတ် တိုကင် ရရှိပါပြီ!') : 'Withdrawal Request Sent!'.tr('ငွေထုတ်ယူခွင့် တောင်းဆိုပြီးပါပြီ!')),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                type == 'atm'
                    ? 'Use the code below at any participating ATM'.tr('အောက်ပါကုဒ်ဖြင့် ATM စက်တွင် ငွေထုတ်ယူနိုင်ပါသည်')
                    : 'Funds are being processed to $destination'.tr('$destination သို့ ငွေလွှဲပြောင်း ဆောင်ရွက်နေပါသည်'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.gray500,
                ),
              ),
              const SizedBox(height: 16),

              // ATM Cardless Box with Live Countdown
              if (type == 'atm') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGold, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('6-Digit ATM Cashout Code'.tr('ATM ငွေထုတ် ကုဒ်'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 12, color: AppColors.error),
                                const SizedBox(width: 4),
                                Text(_formattedCountdown, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        atmOtp,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 6, color: AppColors.primaryDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expires in 15 minutes • Valid for one withdrawal'.tr('၁၅ မိနစ်အတွင်း သက်တမ်းကုန်ဆုံးပါမည်'),
                        style: const TextStyle(fontSize: 11, color: AppColors.gray600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ] else if (type == 'agent') ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceCardDark : AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 56, color: AppColors.primaryDark),
                      const SizedBox(height: 8),
                      Text(agentToken, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppColors.primaryDark)),
                      const SizedBox(height: 4),
                      Text('Show this QR / token code to the agent'.tr('ဤ QR သို့မဟုတ် တိုကင်ကုဒ်ကို ကိုယ်စားလှယ်ထံ ပြသပါ'), style: const TextStyle(fontSize: 11, color: AppColors.gray600)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Deducted Amount
              Text(
                '- ${CurrencyFormatter.formatMMK(amount)}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 16),

              HimoCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildRow(context, 'Destination'.tr('လွှဲပြောင်းမည့် နေရာ'), destination),
                    const Divider(height: 20),
                    _buildRow(context, 'Transaction Ref'.tr('လွှဲပြောင်းမှု အမှတ်'), txId),
                    const Divider(height: 20),
                    _buildRow(context, 'Processing Fee'.tr('ဝန်ဆောင်ခ'), CurrencyFormatter.formatMMK(fee)),
                    const Divider(height: 20),
                    _buildRow(context, 'Total Deducted'.tr('စုစုပေါင်း နုတ်ယူငွေ'), CurrencyFormatter.formatMMK(total)),
                    if (remainingBalance != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, 'Remaining Balance'.tr('ကျန်ရှိသော လက်ကျန်ငွေ'), CurrencyFormatter.formatMMK(remainingBalance), valueColor: AppColors.primaryDark),
                    ],
                    const Divider(height: 20),
                    _buildRow(
                      context,
                      'Status'.tr('အခြေအနေ'),
                      type == 'atm' ? 'Ready for ATM' : (type == 'agent' ? 'Ready for Pickup' : 'Processing (1-2 mins)'.tr('ဆောင်ရွက်နေဆဲ')),
                      valueColor: AppColors.primaryGold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              HimoButton(
                text: 'View Official E-Receipt'.tr('တရားဝင် ပြေစာ ကြည့်မည်'),
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/cashout-receipt',
                    arguments: widget.data,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray300),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/cashout-methods');
                },
                child: Text('Cash Out More'.tr('နောက်ထပ် ငွေထုတ်မည်'), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: AppSpacing.sm),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
                child: Text('Back to Home'.tr('ပင်မစာမျက်နှာသို့'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gray600)),
              ),
            ],
          ),
        ),
        const Positioned.fill(
          child: HimoConfettiOverlay(),
        ),
      ],
    ),
  ),
);
  }

  Widget _buildRow(BuildContext context, String label, String value, {Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? (isDark ? Colors.white : AppColors.gray900),
          ),
        ),
      ],
    );
  }
}


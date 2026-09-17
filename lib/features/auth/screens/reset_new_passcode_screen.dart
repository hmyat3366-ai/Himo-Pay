import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/localization/app_strings.dart';

class ResetNewPasscodeScreen extends StatefulWidget {
  const ResetNewPasscodeScreen({super.key});

  @override
  State<ResetNewPasscodeScreen> createState() => _ResetNewPasscodeScreenState();
}

class _ResetNewPasscodeScreenState extends State<ResetNewPasscodeScreen> {
  final List<int> _pin = [];
  List<int> _firstPin = [];
  bool _isConfirming = false;

  void _onDigit(int digit) {
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));

      if (_pin.length == 6) {
        if (!_isConfirming) {
          // Advance to confirm step
          Future.delayed(const Duration(milliseconds: 250), () {
            if (mounted) {
              setState(() {
                _firstPin = List.from(_pin);
                _pin.clear();
                _isConfirming = true;
              });
            }
          });
        } else {
          // Check if passcodes match
          final isMatch = _firstPin.join() == _pin.join();
          if (isMatch) {
            Future.delayed(const Duration(milliseconds: 250), () {
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/passcode-reset-success');
              }
            });
          } else {
            Future.delayed(const Duration(milliseconds: 250), () {
              if (mounted) {
                HimoToast.show(context, 'Passcodes do not match. Please try again.'.tr('လျှို့ဝှက်ကုဒ် မကိုက်ညီပါ။ ထပ်မံရိုက်ထည့်ပါ'));
                setState(() {
                  _pin.clear();
                });
              }
            });
          }
        }
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title = _isConfirming
        ? 'Confirm New Passcode'.tr('လျှို့ဝှက်ကုဒ် အသစ်ကို အတည်ပြုပါ')
        : 'Set New Passcode'.tr('လျှို့ဝှက်ကုဒ် အသစ် သတ်မှတ်ပါ');

    final subtitle = _isConfirming
        ? 'Re-enter your 6-digit passcode to confirm'.tr('အတည်ပြုရန် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ်ကို ထပ်မံရိုက်ထည့်ပါ')
        : 'Create a new 6-digit passcode to secure your Himo account'
            .tr('သင်၏ Himo အကောင့်အတွက် ဂဏန်း ၆ လုံး လျှို့ဝှက်ကုဒ် အသစ် ရိုက်ထည့်ပါ');

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: HimoAppBar(
        title: '',
        onBack: _isConfirming
            ? () {
                setState(() {
                  _isConfirming = false;
                  _pin.clear();
                });
              }
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Step Indicator Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isConfirming
                    ? 'STEP 2 OF 2: CONFIRMATION'.tr('အဆင့် ၂ - အတည်ပြုခြင်း')
                    : 'STEP 1 OF 2: NEW PASSCODE'.tr('အဆင့် ၁ - လျှို့ဝှက်ကုဒ်အသစ်'),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Animated Title & Subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Column(
                key: ValueKey(_isConfirming),
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.gray900,
                      letterSpacing: -0.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.gray500,
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // 6-Dot Keypad
            HimoKeypad(
              pinLength: _pin.length,
              maxPinLength: 6,
              onDigitPress: _onDigit,
              onDeletePress: _onDelete,
            ),
            const SizedBox(height: AppSpacing.xxl),

            if (_isConfirming)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isConfirming = false;
                    _pin.clear();
                  });
                },
                child: Text(
                  'Change First Passcode'.tr('ပထမ လျှို့ဝှက်ကုဒ် ပြန်ပြောင်းမည်'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

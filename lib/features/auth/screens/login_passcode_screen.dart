import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_biometric_modal.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/storage/app_preferences.dart';

class LoginPasscodeScreen extends StatefulWidget {
  const LoginPasscodeScreen({super.key});

  @override
  State<LoginPasscodeScreen> createState() => _LoginPasscodeScreenState();
}

class _LoginPasscodeScreenState extends State<LoginPasscodeScreen> {
  final List<int> _pin = [];

  void _onDigit(int digit) {
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 250), () async {
          await AppPreferences.setLoggedIn(true);
          if (!mounted) return;
          HimoToast.show(context, 'Login successful!'.tr('အကောင့်ဝင်ရောက်မှု အောင်မြင်ပါသည်'));
          Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
        });
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  Future<void> _onBiometric() async {
    final verified = await HimoBiometricModal.show(
      context,
      title: 'Biometric Login'.tr('လက်ဗွေဖြင့် အကောင့်ဝင်ရန်'),
      subtitle: 'Scan your fingerprint to quickly access your Himo account'
          .tr('Himo အကောင့်သို့ လျင်မြန်စွာ ဝင်ရောက်ရန် လက်ဗွေ စကင်ဖတ်ပါ'),
    );

    if (verified && mounted) {
      await AppPreferences.setLoggedIn(true);
      if (!mounted) return;
      HimoToast.show(context, 'Login successful!'.tr('အကောင့်ဝင်ရောက်မှု အောင်မြင်ပါသည်'));
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: const HimoAppBar(title: ''),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Enter your passcode'.tr('လျှို့ဝှက်ကုဒ် ရိုက်ထည့်ပါ'),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.gray900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Keep your Himo account secure'.tr('သင်၏ Himo အကောင့်ကို လုံခြုံစွာ ထိန်းသိမ်းပါ'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),

                      // Keypad
                      HimoKeypad(
                        pinLength: _pin.length,
                        maxPinLength: 6,
                        onDigitPress: _onDigit,
                        onDeletePress: _onDelete,
                        showBiometric: true,
                        onBiometricPress: _onBiometric,
                      ),
                      const Spacer(),
                      const SizedBox(height: AppSpacing.md),

                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot-passcode');
                        },
                        child: Text(
                          'Forgot passcode?'.tr('လျှို့ဝှက်ကုဒ် မေ့နေပါသလား?'),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

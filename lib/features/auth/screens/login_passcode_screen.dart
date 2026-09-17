import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/himo_biometric_modal.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/storage/app_preferences.dart';

import '../../../core/services/auth_service.dart';

class LoginPasscodeScreen extends StatefulWidget {
  const LoginPasscodeScreen({super.key});

  @override
  State<LoginPasscodeScreen> createState() => _LoginPasscodeScreenState();
}

class _LoginPasscodeScreenState extends State<LoginPasscodeScreen> {
  final List<int> _pin = [];
  String _phone = '';
  String _name = '';
  bool _isAuthenticating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _phone = (args['phone'] as String?) ?? '';
      _name = (args['name'] as String?) ?? '';
    }
    if (_phone.isEmpty) {
      _phone = AppPreferences.activePhone ?? '09 123 456 789';
    }
  }

  void _onDigit(int digit) {
    if (_isAuthenticating) return;
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        _submitPin();
      }
    }
  }

  Future<void> _submitPin() async {
    setState(() => _isAuthenticating = true);
    final pinStr = _pin.join();
    try {
      await AuthService.loginWithPasscode(_phone, pinStr);
      if (!mounted) return;
      HimoToast.show(context, 'Login successful!'.tr('အကောင့်ဝင်ရောက်မှု အောင်မြင်ပါသည်'));
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } catch (e) {
      if (!mounted) return;
      AppPreferences.triggerHaptic(HapticType.heavy);
      final msg = e.toString().replaceAll('Exception: ', '');
      HimoToast.show(context, msg.tr('လျှို့ဝှက်ကုဒ် မှားယွင်းနေပါသည်'));
      setState(() {
        _pin.clear();
      });
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  void _onDelete() {
    if (_isAuthenticating) return;
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
      setState(() => _isAuthenticating = true);
      try {
        final profile = await AuthService.lookupUserByPhone(_phone);
        if (profile != null) {
          final pin = profile['pin_code']?.toString() ?? '123456';
          await AuthService.loginWithPasscode(_phone, pin);
        } else {
          await AuthService.signInAsDemo();
        }
        if (!mounted) return;
        HimoToast.show(context, 'Login successful!'.tr('အကောင့်ဝင်ရောက်မှု အောင်မြင်ပါသည်'));
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
      } catch (e) {
        if (mounted) HimoToast.show(context, 'Biometric login failed: $e');
      } finally {
        if (mounted) setState(() => _isAuthenticating = false);
      }
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
                        _name.isNotEmpty
                            ? 'Signing in as $_name ($_phone)'
                            : 'Keep your Himo account secure'.tr('သင်၏ Himo အကောင့်ကို လုံခြုံစွာ ထိန်းသိမ်းပါ'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray500,
                        ),
                      ),
                      if (_isAuthenticating) ...[
                        const SizedBox(height: 12),
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                        ),
                      ],
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

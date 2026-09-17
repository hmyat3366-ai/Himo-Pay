import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/storage/app_preferences.dart';

import '../../../core/services/auth_service.dart';

class CreatePasscodeScreen extends StatefulWidget {
  const CreatePasscodeScreen({super.key});

  @override
  State<CreatePasscodeScreen> createState() => _CreatePasscodeScreenState();
}

class _CreatePasscodeScreenState extends State<CreatePasscodeScreen> {
  final List<int> _pin = [];
  String _phone = '';
  String _name = '';
  String? _nrc;
  String? _dob;
  String? _gender;
  bool _isCreating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _phone = (args['phone'] as String?) ?? '';
      _name = (args['name'] as String?) ?? '';
      _nrc = args['nrc'] as String?;
      _dob = args['dob'] as String?;
      _gender = args['gender'] as String?;
    }
  }

  void _onDigit(int digit) {
    if (_isCreating) return;
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        _submitNewPasscode();
      }
    }
  }

  Future<void> _submitNewPasscode() async {
    setState(() => _isCreating = true);
    final pinStr = _pin.join();
    try {
      await AuthService.signUpNewUser(
        phone: _phone.isNotEmpty ? _phone : '09950786548',
        name: _name.isNotEmpty ? _name : 'HTET MYAT OO',
        passcode: pinStr,
        nrc: _nrc,
        dob: _dob,
        gender: _gender,
      );
      if (!mounted) return;
      HimoToast.show(context, 'Account created successfully! Welcome to Himo Pay.');
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } catch (e) {
      if (!mounted) return;
      AppPreferences.triggerHaptic(HapticType.heavy);
      final msg = e.toString().replaceAll('Exception: ', '');
      HimoToast.show(context, msg);
      setState(() => _pin.clear());
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _onDelete() {
    if (_isCreating) return;
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                        'Create your passcode',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.gray900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Choose a 6-digit passcode to secure your Himo account.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray500,
                        ),
                      ),
                      if (_isCreating) ...[
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
                      ),
                      const Spacer(),
                      const SizedBox(height: AppSpacing.md),

                      // Security note
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, size: 14, color: AppColors.primaryDark),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Do not share your passcode with anyone, including Himo Pay support.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.gray400 : AppColors.gray500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
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

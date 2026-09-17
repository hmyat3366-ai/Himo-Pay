import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_keypad.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/storage/app_preferences.dart';

class CreatePasscodeScreen extends StatefulWidget {
  const CreatePasscodeScreen({super.key});

  @override
  State<CreatePasscodeScreen> createState() => _CreatePasscodeScreenState();
}

class _CreatePasscodeScreenState extends State<CreatePasscodeScreen> {
  final List<int> _pin = [];

  void _onDigit(int digit) {
    if (_pin.length < 6) {
      setState(() => _pin.add(digit));
      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 250), () async {
          await AppPreferences.setLoggedIn(true);
          if (!mounted) return;
          HimoToast.show(context, 'Passcode created successfully!');
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

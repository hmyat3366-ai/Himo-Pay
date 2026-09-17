import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/services/auth_service.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _countdown = 59;
  Timer? _timer;
  bool _isLoading = false;
  String _phone = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _phone = (args['phone'] as String?) ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
    for (var f in _focusNodes) {
      f.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = 59);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final lastChar = value[value.length - 1];
      _controllers[index].text = lastChar;
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
    }
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4 && !_isLoading) {
      _verifyOtp(code);
    }
  }

  Future<void> _verifyOtp(String code) async {
    setState(() => _isLoading = true);
    try {
      if (_phone.isEmpty) {
        // Demo mode: no real phone, go to passcode screen
        if (mounted) Navigator.of(context).pushNamed('/login-passcode');
        return;
      }
      await AuthService.verifyOtp(_phone, code);
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (r) => false);
      }
    } catch (e) {
      if (mounted) {
        HimoToast.show(context, 'Invalid OTP code. Please try again.'.tr('OTP ကုဒ်မှားနေသည်'));
        for (var c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: const HimoAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verification Code'.tr('အတည်ပြုကုဒ်'),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.gray900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter the 4-digit code sent to +95 9*****6548'.tr('+95 9*****6548 သို့ ပေးပို့ထားသော ဂဏန်း ၄ လုံးကုဒ် ရိုက်ထည့်ပါ'),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 4 OTP Input Boxes (Perfect symmetry, unified spacing, no theme border clash)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFocused = _focusNodes[index].hasFocus;
                    final hasValue = _controllers[index].text.isNotEmpty;

                    return Container(
                      width: 62,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceCardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isFocused
                              ? AppColors.primary
                              : (hasValue
                                  ? (isDark ? AppColors.primary : AppColors.primaryDark)
                                  : (isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFD1D5DB))),
                          width: isFocused ? 2.0 : 1.2,
                        ),
                        boxShadow: [
                          if (isFocused)
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.22),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            )
                          else
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Focus(
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.backspace &&
                                _controllers[index].text.isEmpty &&
                                index > 0) {
                              _focusNodes[index - 1].requestFocus();
                              _controllers[index - 1].clear();
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            maxLength: 1,
                            cursorColor: AppColors.primary,
                            cursorWidth: 2,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.gray900,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                            onChanged: (val) => _onDigitChanged(index, val),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Resend Countdown
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Resend code in '.tr('ကုဒ်ပြန်ပို့ရန် ကျန်ချိန် - '),
                      style: TextStyle(color: isDark ? AppColors.gray400 : AppColors.gray500),
                    ),
                    Text(
                      '00:${_countdown.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: _countdown == 0
                      ? () {
                          _startCountdown();
                          HimoToast.show(context, 'New SMS OTP code sent'.tr('OTP ကုဒ်အသစ် ပေးပို့ပြီးပါပြီ'));
                        }
                      : null,
                  child: Text(
                    'Resend Code'.tr('ကုဒ်ပြန်လည်ရယူမည်'),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _countdown == 0 ? AppColors.primary : AppColors.gray400,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Verify Button
              HimoButton(
                text: 'Verify'.tr('အတည်ပြုမည်'),
                isLoading: _isLoading,
                onPressed: _isLoading
                    ? null
                    : () {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length < 4) {
                          HimoToast.show(context, 'Please enter 4-digit code'.tr('ဂဏန်း ၄ လုံးထည့်ပါ'));
                          return;
                        }
                        _verifyOtp(code);
                      },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

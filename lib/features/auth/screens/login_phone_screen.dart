import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/locale_manager.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/services/auth_service.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '950786548');
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<String>(
      valueListenable: LocaleManager.currentLocale,
      builder: (context, localeCode, _) {
        return Scaffold(
          appBar: HimoAppBar(
            title: '',
            showBack: false,
            actions: [
              // Language Switcher Badge
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () {
                    LocaleManager.toggle();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.12) : AppColors.gray300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 15, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          LocaleManager.languageBadge,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Welcome Back'.tr('ပြန်လည်ကြိုဆိုပါသည်'),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.gray900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Enter your mobile number to sign in to your Himo account.'
                                .tr('Himo အကောင့်သို့ ဝင်ရောက်ရန် သင့်ဖုန်းနံပါတ်ကို ရိုက်ထည့်ပါ'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.gray500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),

                          // Phone Input Field
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceCardDark : Colors.white,
                              borderRadius: AppRadius.cardBorder,
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Row(
                              children: [
                                // Country Flag & Code (+95)
                                const Text('🇲🇲', style: TextStyle(fontSize: 22)),
                                const SizedBox(width: 8),
                                Text(
                                  '+95',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : AppColors.gray900,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(width: 1, height: 24, color: AppColors.gray300),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : AppColors.gray900,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '9xxxxxxxxx',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                      filled: false,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      hintStyle: TextStyle(color: AppColors.gray400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Spacer(),

                          // Continue Button
                          HimoButton(
                            text: 'Continue'.tr('ဆက်လုပ်မည်'),
                            isLoading: _isLoading,
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    final phone = _phoneController.text.trim();
                                    if (phone.isEmpty) {
                                      HimoToast.show(context, 'Please enter your phone number'.tr('ဖုန်းနံပါတ်ထည့်ပါ'));
                                      return;
                                    }
                                    setState(() => _isLoading = true);
                                    try {
                                      await AuthService.sendOtp(phone);
                                      if (context.mounted) {
                                        Navigator.of(context).pushNamed(
                                          '/login-otp',
                                          arguments: {'phone': phone},
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        HimoToast.show(context, 'Failed to send OTP. Try Demo Login.'.tr('OTP မပေးပို့နိုင်ပါ'));
                                      }
                                    } finally {
                                      if (mounted) setState(() => _isLoading = false);
                                    }
                                  },
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Quick Demo Login Button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              await AuthService.signInAsDemo();
                              if (context.mounted) {
                                HimoToast.show(context, 'Welcome to Himo Pay Demo!'.tr('Himo Pay စမ်းသပ်ဗားရှင်းမှ ကြိုဆိုပါသည်'));
                                Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                              }
                            },
                            icon: const Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20),
                            label: Text(
                              'Quick Demo Login'.tr('အစမ်းအကောင့်ဖြင့် ချက်ချင်းဝင်မည်'),
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.sm),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushNamed('/signup-phone'),
                              child: Text(
                                "Don't have an account? Sign up".tr('အကောင့်မရှိသေးဘူးလား? အသစ်ဖွင့်မည်'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

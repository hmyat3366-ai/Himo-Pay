import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/locale_manager.dart';

class SignupPhoneScreen extends StatefulWidget {
  const SignupPhoneScreen({super.key});

  @override
  State<SignupPhoneScreen> createState() => _SignupPhoneScreenState();
}

class _SignupPhoneScreenState extends State<SignupPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _agreedToTerms = true;

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
            onBack: () => Navigator.of(context).pushReplacementNamed('/login-phone'),
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
                          Text(
                            'Create Account'.tr('အကောင့်အသစ်ဖွင့်မည်'),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : AppColors.gray900,
                              letterSpacing: -0.6,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Enter your phone number to get started with Himo Pay.'
                                .tr('Himo Pay ကို စတင်အသုံးပြုရန် သင့်ဖုန်းနံပါတ်ကို ရိုက်ထည့်ပါ'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.gray500,
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
                          const SizedBox(height: AppSpacing.lg),

                          // Agreement Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                activeColor: AppColors.primary,
                                onChanged: (v) => setState(() => _agreedToTerms = v ?? true),
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the Himo Pay Terms of Service and Privacy Policy.'
                                      .tr('Himo Pay ဝန်ဆောင်မှုစည်းကမ်းချက်များနှင့် ကိုယ်ရေးကိုယ်တာမူဝါဒကို သဘောတူပါသည်'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.gray300 : AppColors.gray700,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          const Spacer(),

                          HimoButton(
                            text: 'Next'.tr('ရှေ့သို့'),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/kyc-personal');
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/login-phone'),
                              child: Text(
                                'Already have an account? Sign In'.tr('အကောင့်ရှိပြီးသားလား? အကောင့်ဝင်မည်'),
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

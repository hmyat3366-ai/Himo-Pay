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
  late final TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final savedPhone = AppPreferences.activePhone;
    if (savedPhone != null && savedPhone.isNotEmpty) {
      final digits = savedPhone.replaceAll(RegExp(r'\D'), '');
      _phoneController = TextEditingController(
        text: digits.startsWith('09') ? digits.substring(2) : digits,
      );
    } else {
      _phoneController = TextEditingController(text: '123456789');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showDemoAccountsModal(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Demo Account'.tr('စမ်းသပ်အကောင့် ရွေးချယ်ပါ'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDemoUserTile(
                  name: 'HTET MYAT OO',
                  phone: '09 950 786 548',
                  balance: '2,500,000 MMK',
                  userId: 'user-htet-myat-oo',
                  isDark: isDark,
                  onSelect: () => _loginAsDemo(ctx, 'user-htet-myat-oo'),
                ),
                const SizedBox(height: 10),
                _buildDemoUserTile(
                  name: 'Min Khant',
                  phone: '09 123 456 789',
                  balance: '1,250,000 MMK',
                  userId: 'user-min-khant',
                  isDark: isDark,
                  onSelect: () => _loginAsDemo(ctx, 'user-min-khant'),
                ),
                const SizedBox(height: 10),
                _buildDemoUserTile(
                  name: 'Aung Aung',
                  phone: '09 987 654 321',
                  balance: '500,000 MMK',
                  userId: 'user-aung-aung',
                  isDark: isDark,
                  onSelect: () => _loginAsDemo(ctx, 'user-aung-aung'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDemoUserTile({
    required String name,
    required String phone,
    required String balance,
    required String userId,
    required bool isDark,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: Text(
                name[0],
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(phone, style: const TextStyle(color: AppColors.gray500, fontSize: 13)),
                ],
              ),
            ),
            Text(balance, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }

  Future<void> _loginAsDemo(BuildContext modalCtx, String userId) async {
    Navigator.pop(modalCtx);
    setState(() => _isLoading = true);
    try {
      await AuthService.signInAsDemo(demoUserId: userId);
      if (mounted) {
        HimoToast.show(context, 'Login successful!'.tr('အကောင့်ဝင်ရောက်မှု အောင်မြင်ပါသည်'));
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (r) => false);
      }
    } catch (e) {
      if (mounted) {
        HimoToast.show(context, 'Demo login error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                                    final raw = _phoneController.text.trim();
                                    if (raw.isEmpty) {
                                      HimoToast.show(context, 'Please enter your phone number'.tr('ဖုန်းနံပါတ်ထည့်ပါ'));
                                      return;
                                    }
                                    setState(() => _isLoading = true);
                                    try {
                                      final profile = await AuthService.lookupUserByPhone(raw);
                                      if (!mounted) return;
                                      if (profile != null) {
                                        Navigator.of(context).pushNamed(
                                          '/login-passcode',
                                          arguments: {
                                            'phone': profile['phone']?.toString() ?? raw,
                                            'name': profile['name']?.toString() ?? 'Himo User',
                                            'id': profile['id']?.toString() ?? '',
                                          },
                                        );
                                      } else {
                                        // Account not found - offer to sign up
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            title: Text(
                                              'Account Not Found'.tr('အကောင့်မတွေ့ပါ'),
                                              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                                            ),
                                            content: Text(
                                              'This phone number ($raw) is not registered yet. Would you like to create a new account?'
                                                  .tr('ဤဖုန်းနံပါတ်ဖြင့် အကောင့်ဖွင့်ထားခြင်း မရှိသေးပါ။ အကောင့်အသစ် ဖွင့်လိုပါသလား?'),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx),
                                                child: Text('Cancel'.tr('မလုပ်တော့ပါ')),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  Navigator.of(context).pushNamed(
                                                    '/signup-phone',
                                                    arguments: {'phone': raw},
                                                  );
                                                },
                                                child: Text(
                                                  'Sign Up'.tr('အကောင့်ဖွင့်မည်'),
                                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        HimoToast.show(context, 'Network error: $e');
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
                            onPressed: () => _showDemoAccountsModal(isDark),
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

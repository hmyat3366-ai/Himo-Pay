import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/language_selection_modal.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/locale_manager.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/repositories/himo_repository.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDark;

  const ProfileScreen({super.key, this.onToggleTheme, this.isDark = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HimoRepository _repo = HimoRepository();

  @override
  void initState() {
    super.initState();
    _repo.walletNotifier.addListener(_onProfileChanged);
    _repo.userNotifier.addListener(_onProfileChanged);
    _repo.fetchFromSupabase();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.walletNotifier.removeListener(_onProfileChanged);
    _repo.userNotifier.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(AppStrings.logOut, style: const TextStyle(fontWeight: FontWeight.w800)),
          content: Text('Are you sure you want to log out of your Himo Pay account?'.tr('Himo Pay အကောင့်မှ အမှန်တကယ် ထွက်လိုပါသလား?'), style: const TextStyle(fontSize: 13)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppStrings.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () async {
                await AuthService.signOut();
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login-phone', (route) => false);
                }
              },
              child: Text(AppStrings.logOut, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = _repo.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppStrings.navProfile, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
          children: [
            // User Card
            HimoCard(
              onTap: () => Navigator.of(context).pushNamed('/personal-information'),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/avatar_profile.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: -0.2), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(user.maskedPhone, style: const TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 2,
                          children: [
                            Text(user.tier.tr('အသုံးပြုသူ အဆင့် ၂'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            Text('(Approved)'.tr('(အတည်ပြုပြီး)'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.gray400, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Group 1: User Level, Limits & Fees, Referral, Share, About
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.emoji_events_outlined,
                    title: 'User Level 2'.tr('အသုံးပြုသူ အဆင့် ၂'),
                    badge: '(Approved)'.tr('(အတည်ပြုပြီး)'),
                    badgeColor: AppColors.success,
                    onTap: () => Navigator.of(context).pushNamed('/user-level'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: AppStrings.limitsFees,
                    onTap: () => Navigator.of(context).pushNamed('/limits-fees'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.card_giftcard_rounded,
                    title: AppStrings.referralCode,
                    onTap: () => Navigator.of(context).pushNamed('/referral-code'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.share_outlined,
                    title: 'Share Himo Pay App'.tr('Himo Pay အက်ပ် သူငယ်ချင်းများထံ မျှဝေမည်'),
                    onTap: () => HimoToast.show(context, 'Himo Pay download link copied to clipboard!'.tr('Himo Pay ဒေါင်းလုဒ်လင့်ခ် ကူးယူပြီးပါပြီ')),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.info_outline_rounded,
                    title: AppStrings.aboutHimoPay,
                    onTap: () => Navigator.of(context).pushNamed('/about-himopay'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Group 2: Security & App Settings
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.shield_outlined,
                    title: AppStrings.securityPrivacy,
                    onTap: () => Navigator.of(context).pushNamed('/security-privacy'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.pin_outlined,
                    title: AppStrings.otpSettings,
                    onTap: () => Navigator.of(context).pushNamed('/otp-settings'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.language_rounded,
                    title: AppStrings.appLanguage,
                    badge: LocaleManager.languageName,
                    onTap: () => LanguageSelectionModal.show(context),
                  ),
                  _buildDivider(isDark),
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: AppStrings.darkMode,
                    value: isDark,
                    onChanged: (val) {
                      if (widget.onToggleTheme != null) {
                        widget.onToggleTheme!();
                      }
                    },
                  ),
                  _buildDivider(isDark),
                  ValueListenableBuilder<bool>(
                    valueListenable: AppPreferences.soundEffectsNotifier,
                    builder: (context, soundEnabled, _) {
                      return _buildSwitchTile(
                        icon: Icons.volume_up_outlined,
                        title: AppStrings.soundEffects,
                        value: soundEnabled,
                        onChanged: (val) => AppPreferences.toggleSoundEffects(),
                      );
                    },
                  ),
                  _buildDivider(isDark),
                  ValueListenableBuilder<bool>(
                    valueListenable: AppPreferences.autoReceiptNotifier,
                    builder: (context, autoReceiptEnabled, _) {
                      return _buildSwitchTile(
                        icon: Icons.receipt_outlined,
                        title: AppStrings.autoReceipt,
                        value: autoReceiptEnabled,
                        onChanged: (val) => AppPreferences.toggleAutoReceipt(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Group 3: Support & Feedback
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildNavTile(
                    icon: Icons.headset_mic_outlined,
                    title: AppStrings.liveSupport,
                    badge: 'Online'.tr('အွန်လိုင်း'),
                    badgeColor: AppColors.success,
                    onTap: () => Navigator.of(context).pushNamed('/live-support'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.help_outline_rounded,
                    title: AppStrings.helpCenter,
                    onTap: () => Navigator.of(context).pushNamed('/help-center'),
                  ),
                  _buildDivider(isDark),
                  _buildNavTile(
                    icon: Icons.rate_review_outlined,
                    title: AppStrings.feedback,
                    onTap: () => Navigator.of(context).pushNamed('/feedback'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Log Out button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: Text(AppStrings.logOut, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Text(badge, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: badgeColor ?? AppColors.primary)),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.gray400),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Switch(
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, indent: 52, color: isDark ? AppColors.borderDark : AppColors.gray200);
  }
}

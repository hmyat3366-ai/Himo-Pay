import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool _biometricEnabled = true;
  bool _twoFactor = true;
  bool _hideBalanceRecorder = true;
  bool _blockScreenshots = false;

  void _promptChangePasscode() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Passcode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        content: const Text('An authorization code will be sent to your registered mobile number.', style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushNamed('/create-passcode');
            },
            child: const Text('Proceed', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HimoAppBar(title: 'Security & Privacy'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const Text('AUTHENTICATION & PASSCODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primaryGold),
                    title: const Text('Change 6-Digit Passcode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: _promptChangePasscode,
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.gray200),
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryGold),
                    title: const Text('FaceID / Fingerprint Login', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Quick authentication for transfers and unlock', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                    value: _biometricEnabled,
                    activeThumbColor: AppColors.primaryGold,
                    onChanged: (val) {
                      setState(() => _biometricEnabled = val);
                      HimoToast.show(context, val ? 'Biometrics enabled' : 'Biometrics disabled');
                    },
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.gray200),
                  SwitchListTile(
                    secondary: const Icon(Icons.security_rounded, color: AppColors.primaryGold),
                    title: const Text('Two-Factor Authentication (2FA)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('SMS OTP verification for unusual activities', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                    value: _twoFactor,
                    activeThumbColor: AppColors.primaryGold,
                    onChanged: (val) => setState(() => _twoFactor = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('PRIVACY & SCREEN PROTECTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.visibility_off_outlined, color: AppColors.primaryGold),
                    title: const Text('Hide Balances in Screen Share', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    value: _hideBalanceRecorder,
                    activeThumbColor: AppColors.primaryGold,
                    onChanged: (val) => setState(() => _hideBalanceRecorder = val),
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.gray200),
                  SwitchListTile(
                    secondary: const Icon(Icons.screenshot_outlined, color: AppColors.primaryGold),
                    title: const Text('Block In-App Screenshots', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    value: _blockScreenshots,
                    activeThumbColor: AppColors.primaryGold,
                    onChanged: (val) => setState(() => _blockScreenshots = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('ACTIVE LOGIN SESSIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.phone_iphone_rounded, color: AppColors.success, size: 28),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('iPhone 16 Pro Max (This Device)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Yangon, Myanmar • Active Now', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('CURRENT', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

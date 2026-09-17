import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class OtpSettingsScreen extends StatefulWidget {
  const OtpSettingsScreen({super.key});

  @override
  State<OtpSettingsScreen> createState() => _OtpSettingsScreenState();
}

class _OtpSettingsScreenState extends State<OtpSettingsScreen> {
  int _selectedMethod = 0; // 0: SMS, 1: Authenticator App, 2: Telegram Bot
  bool _autoFill = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'OTP Settings'.tr('OTP ဆက်တင်များ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text('PRIMARY OTP CHANNEL'.tr('အဓိက OTP လက်ခံမည့် နည်းလမ်း'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            _buildOption(0, 'SMS Verification (Default)', 'Sent to +95 9950786548', Icons.sms_outlined, isDark),
            const SizedBox(height: 10),
            _buildOption(1, 'Authenticator App (TOTP)', 'Google Authenticator / 1Password', Icons.lock_clock_outlined, isDark),
            const SizedBox(height: 10),
            _buildOption(2, 'Official Telegram Bot', 'Direct instant secure telegram push', Icons.send_rounded, isDark),
            const SizedBox(height: 24),
            Text('AUTOFILL & CODES'.tr('အလိုအလျောက် ဖြည့်စွက်ခြင်း'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            HimoCard(
              padding: EdgeInsets.zero,
              child: SwitchListTile(
                title: Text('Auto-Fill SMS Verification Codes'.tr('SMS စိစစ်ရေးကုဒ် အလိုအလျောက် ဖြည့်မည်'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Automatically extract 6-digit codes on receive', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                value: _autoFill,
                activeColor: AppColors.primaryGold,
                onChanged: (val) => setState(() => _autoFill = val),
              ),
            ),
            const SizedBox(height: 28),
            HimoButton(
              text: 'Send Test Verification Code'.tr('စမ်းသပ် OTP ကုဒ် ပို့မည်'),
              onPressed: () {
                HimoToast.show(context, 'Test verification code: 582-910 sent to primary channel.');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int idx, String title, String sub, IconData icon, bool isDark) {
    final isSelected = _selectedMethod == idx;
    return HimoCard(
      onTap: () {
        setState(() => _selectedMethod = idx);
        HimoToast.show(context, 'Preferred channel updated to $title');
      },
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryGold : AppColors.gray500, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
              ],
            ),
          ),
          Radio<int>(
            value: idx,
            groupValue: _selectedMethod,
            activeColor: AppColors.primaryGold,
            onChanged: (val) {
              if (val != null) setState(() => _selectedMethod = val);
            },
          ),
        ],
      ),
    );
  }
}

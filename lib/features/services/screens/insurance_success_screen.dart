import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class InsuranceSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const InsuranceSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = data?['title'] ?? 'Personal Accident Protection';
    final policyNo = data?['policyNo'] ?? 'POL-849204';
    final premium = (data?['premium'] as num?)?.toInt() ?? 12000;
    final underwriter = data?['underwriter'] ?? 'IKBZ Insurance';
    final user = data?['user'] ?? 'Htet Myat Oo';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.15),
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(Icons.shield_outlined, color: AppColors.success, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'Policy Activated!'.tr('အာမခံ အောင်မြင်စွာ ရယူပြီးပါပြီ!'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Your insurance coverage is now active'.tr('သင့်အာမခံ အကာအကွယ် စတင် အသက်ဝင်ပါပြီ'),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(underwriter, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                    const Divider(height: 24),
                    _buildRow(context, 'Policy Number'.tr('အာမခံ ပေါ်လစီ အမှတ်'), policyNo),
                    const Divider(height: 20),
                    _buildRow(context, 'Insured Member'.tr('အာမခံထားရှိသူ'), user),
                    const Divider(height: 20),
                    _buildRow(context, 'Coverage Period'.tr('အကာအကွယ် သက်တမ်း'), '1 Year (Active immediately)'.tr('၁ နှစ် (ချက်ချင်း အသက်ဝင်သည်)')),
                    const Divider(height: 20),
                    _buildRow(context, 'Premium Paid'.tr('ပေးသွင်းပြီး ပရီမီယံကြေး'), CurrencyFormatter.formatMMK(premium)),
                    const Divider(height: 20),
                    _buildRow(context, 'Policy Status'.tr('အခြေအနေ'), 'Active & Insured'.tr('အာမခံ အကျုံးဝင်နေဆဲ'), valueColor: AppColors.success),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              HimoButton(
                text: 'Done'.tr('ပြီးပါပြီ'),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

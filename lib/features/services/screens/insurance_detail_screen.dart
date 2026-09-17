import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class InsuranceDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const InsuranceDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final repo = HimoRepository();
    final user = repo.currentUser;

    final title = data?['title'] ?? 'Personal Accident Protection';
    final premium = (data?['premium'] as num?)?.toInt() ?? 12000;
    final period = data?['period'] ?? '/ year';
    final underwriter = data?['underwriter'] ?? 'IKBZ Insurance Partner';

    void subscribe() {
      if (repo.balance < premium) {
        HimoToast.show(context, 'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
        return;
      }

      final policyNo = 'POL-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      repo.deductBalance(premium);
      repo.addPoints((premium / 500).round());
      repo.addTransaction(
        TransactionModel(
          id: 'HM-IN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: '$title Premium',
          date: 'Just now'.tr('ယခုလေးတင်'),
          amount: premium,
          type: TransactionType.outMoney,
          category: 'Insurance',
        ),
      );

      Navigator.of(context).pushReplacementNamed(
        '/insurance-success',
        arguments: {
          'title': title,
          'policyNo': policyNo,
          'premium': premium,
          'underwriter': underwriter,
          'user': user.name,
        },
      );
    }

    return Scaffold(
      appBar: HimoAppBar(title: 'Policy Details'.tr('အာမခံ အသေးစိတ်')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  HimoCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('${'Underwritten by '.tr('အာမခံပေးသူ: ')}$underwriter', style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              CurrencyFormatter.formatMMK(premium),
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                            ),
                            Text(' $period', style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('COVERAGE SUMMARY'.tr('အာမခံ အကာအကွယ် အကျဉ်းချုပ်'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 10),
                  _buildBenefitRow(Icons.check_circle_rounded, 'Accidental death & permanent disability compensation up to 10,000,000 MMK.'),
                  _buildBenefitRow(Icons.check_circle_rounded, 'Emergency hospital room and board allowance up to 300,000 MMK/stay.'),
                  _buildBenefitRow(Icons.check_circle_rounded, 'Direct cashless billing at over 40 affiliated private hospitals.'),
                  _buildBenefitRow(Icons.check_circle_rounded, '24/7 emergency hotline & digital claims via Himo Pay app.'),
                  const SizedBox(height: 20),
                  Text('INSURED PERSON'.tr('အာမခံထားရှိသူ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 10),
                  HimoCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow('Full Name', user.name),
                        const Divider(height: 16),
                        _buildInfoRow('Phone', user.phone),
                        const Divider(height: 16),
                        _buildInfoRow('KYC Identity', 'Verified Tier 2 (National ID)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200)),
              ),
              child: HimoButton(
                text: 'Activate Policy • '.tr('အာမခံ စတင်ရယူမည် • ') + CurrencyFormatter.formatMMK(premium),
                onPressed: subscribe,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.success, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.4))),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

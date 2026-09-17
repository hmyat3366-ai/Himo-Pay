import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class MoviesSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const MoviesSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = data?['title'] ?? 'Inception';
    final cinema = data?['cinema'] ?? 'JCGV Junction City';
    final time = data?['time'] ?? '4:30 PM';
    final seats = data?['seats'] ?? 'C3, C4';
    final total = (data?['total'] as num?)?.toInt() ?? 22000;
    final code = data?['code'] ?? 'CIN-884920';

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
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 44),
              ),
              const SizedBox(height: 20),
              Text(
                'Cinema Tickets Confirmed!'.tr('ရုပ်ရှင်လက်မှတ် ဝယ်ယူမှု အောင်မြင်ပါသည်!'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Present this e-ticket at the cinema entrance'.tr('ရုပ်ရှင်ရုံ အဝင်ဝတွင် ဤ e-လက်မှတ်ကို ပြသပေးပါ'),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(cinema, style: const TextStyle(fontSize: 12, color: AppColors.gray500), textAlign: TextAlign.center),
                    const Divider(height: 24),
                    Container(
                      width: 140,
                      height: 140,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Image.asset('assets/images/illustration_qr_payment.jpg'),
                    ),
                    const SizedBox(height: 10),
                    Text('${'BOOKING CODE:'.tr('ဘွတ်ကင်ကုဒ်:')} $code', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.primaryDark)),
                    const Divider(height: 24),
                    _buildRow(context, 'Showtime'.tr('ရုပ်ရှင်ပြသမည့် အချိန်'), '${'Today • '.tr('ယနေ့ • ')}$time'),
                    const SizedBox(height: 8),
                    _buildRow(context, 'Seats Allocated'.tr('ရရှိသော ထိုင်ခုံများ'), seats, isBold: true),
                    const SizedBox(height: 8),
                    _buildRow(context, 'Total Paid'.tr('စုစုပေါင်း ကျသင့်ငွေ'), CurrencyFormatter.formatMMK(total)),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/my-tickets');
                },
                icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                label: Text('View in My Tickets'.tr('ကျွန်ုပ်၏ လက်မှတ်များတွင် ကြည့်မည်')),
              ),
              const SizedBox(height: 12),
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

  Widget _buildRow(BuildContext context, String label, String value, {bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primaryDark : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/utils/currency_formatter.dart';

class EventsSuccessScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const EventsSuccessScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = data?['title'] ?? 'Tech Innovators Summit';
    final venue = data?['venue'] ?? 'Lotte Hotel Grand Ballroom';
    final date = data?['date'] ?? '26 SEP 2026';
    final quantity = (data?['quantity'] as num?)?.toInt() ?? 1;
    final tier = data?['tier'] ?? 'Standard Pass';
    final total = (data?['total'] as num?)?.toInt() ?? 45000;
    final ticketCode = data?['ticketCode'] ?? 'EVT-9921401';

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
                'E-Ticket Confirmed!'.tr('E-လက်မှတ် ဝယ်ယူမှု အောင်မြင်ပါသည်!'),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Your pass is ready for check-in'.tr('သင့်လက်မှတ်ကို စကင်ဖတ် ဝင်ရောက်နိုင်ပါပြီ'),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 24),
              HimoCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text('$date • $venue', style: const TextStyle(fontSize: 12, color: AppColors.gray500), textAlign: TextAlign.center),
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
                    Text(ticketCode, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.primaryDark)),
                    const Divider(height: 24),
                    _buildRow(context, 'Pass Tier'.tr('လက်မှတ် အမျိုးအစား'), '$tier (x$quantity)'),
                    const SizedBox(height: 8),
                    _buildRow(context, 'Total Amount'.tr('စုစုပေါင်း ကျသင့်ငွေ'), CurrencyFormatter.formatMMK(total), isBold: true),
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
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primaryDark : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

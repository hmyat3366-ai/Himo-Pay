import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../data/models/ticket_model.dart';

class TicketDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TicketDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ticket = data?['ticket'] as TicketModel? ??
        TicketModel(
          id: 'TICKET-DEFAULT',
          title: 'Yangon Tech Summit 2026',
          venue: 'Lotte Hotel Ballroom',
          date: '26 Sep 2026 • 9:00 AM',
          type: TicketType.event,
          code: 'EVT-990421',
          seat: 'VIP Row A-04',
        );

    final isPast = data?['isPast'] as bool? ?? false;

    return Scaffold(
      appBar: HimoAppBar(title: 'Digital Pass'.tr('ဒစ်ဂျစ်တယ် လက်မှတ်')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.gray200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withOpacity(0.15),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                ticket.type == TicketType.event ? Icons.confirmation_number_outlined : Icons.movie_outlined,
                                color: AppColors.primaryGold,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ticket.type == TicketType.event ? 'OFFICIAL EVENT PASS'.tr('ပွဲ ဝင်ခွင့်လက်မှတ်') : 'CINEMA ENTRY PASS'.tr('ရုပ်ရှင်ရုံ ဝင်ခွင့်လက်မှတ်'),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5, color: AppColors.primaryDark),
                              ),
                              const Spacer(),
                              Text(
                                isPast ? 'USED'.tr('အသုံးပြုပြီး') : 'VALID'.tr('အသုံးပြုနိုင်'),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  color: isPast ? AppColors.gray500 : AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                ticket.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${ticket.date}\n${ticket.venue}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : AppColors.gray100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${'Seat:'.tr('ထိုင်ခုံ:')} ${ticket.seat}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(height: 24),
                              // Barcode & QR
                              Container(
                                width: 170,
                                height: 170,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.gray200),
                                ),
                                child: Image.asset('assets/images/illustration_qr_payment.jpg'),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                ticket.code,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.primaryDark),
                              ),
                              const SizedBox(height: 4),
                              Text('Scan at turnstile or usher reader'.tr('ဂိတ်ပေါက် သို့မဟုတ် တာဝန်ကျဝန်ထမ်းထံတွင် စကင်ဖတ်ပါ'), style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        HimoToast.show(context, 'Pass added to Google Wallet'.tr('လက်မှတ်ကို Google Wallet သို့ ထည့်ပြီးပါပြီ'));
                      },
                      icon: const Icon(Icons.wallet_rounded, size: 18),
                      label: Text('Add to Wallet'.tr('ပိုက်ဆံအိတ်သို့ ထည့်မည်')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HimoButton(
                      text: 'Share Pass'.tr('လက်မှတ် မျှဝေမည်'),
                      onPressed: () {
                        HimoToast.show(context, 'Pass link ready to share'.tr('လက်မှတ်လင့်ခ်ကို မျှဝေရန် အဆင်သင့်ဖြစ်ပါပြီ'));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

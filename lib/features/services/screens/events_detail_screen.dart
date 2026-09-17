import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/ticket_model.dart';

class EventsDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EventsDetailScreen({super.key, this.data});

  @override
  State<EventsDetailScreen> createState() => _EventsDetailScreenState();
}

class _EventsDetailScreenState extends State<EventsDetailScreen> {
  final HimoRepository _repo = HimoRepository();
  int _ticketQuantity = 1;
  int _selectedTierIndex = 0; // 0: Regular, 1: VIP (+25,000 MMK)

  void _bookEvent(String title, String venue, String date, int basePrice) {
    final tierPrice = _selectedTierIndex == 0 ? basePrice : basePrice + 25000;
    final total = tierPrice * _ticketQuantity;

    if (_repo.balance < total) {
      HimoToast.show(context, 'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    final ticketCode = 'EVT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    _repo.deductBalance(total);
    _repo.addPoints((total / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-EV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '$title Ticket'.tr('$title လက်မှတ်'),
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: total,
        type: TransactionType.outMoney,
        category: 'Event Ticket'.tr('ပွဲလက်မှတ်'),
      ),
    );

    _repo.addTicket(
      TicketModel(
        id: ticketCode,
        title: title,
        venue: venue,
        date: date,
        type: TicketType.event,
        code: ticketCode,
        seat: _selectedTierIndex == 0 ? 'General Admission' : 'VIP Lounge Access',
      ),
    );

    Navigator.of(context).pushReplacementNamed(
      '/events-success',
      arguments: {
        'title': title,
        'venue': venue,
        'date': date,
        'quantity': _ticketQuantity,
        'tier': _selectedTierIndex == 0 ? 'Standard Pass' : 'VIP Priority Pass',
        'total': total,
        'ticketCode': ticketCode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.data?['title'] ?? 'Yangon Tech Innovators Summit 2026';
    final venue = widget.data?['venue'] ?? 'Lotte Hotel Grand Ballroom • 9:00 AM';
    final date = widget.data?['date'] ?? '26 SEP 2026';
    final image = widget.data?['image'] ?? 'assets/images/event_visual_rewards.jpg';
    final basePrice = (widget.data?['price'] as num?)?.toInt() ?? 45000;

    final currentUnitPrice = _selectedTierIndex == 0 ? basePrice : basePrice + 25000;
    final total = currentUnitPrice * _ticketQuantity;

    return Scaffold(
      appBar: HimoAppBar(title: 'Event Booking'.tr('ပွဲလက်မှတ် ဝယ်ယူရန်')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(image, height: 160, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primaryGold),
                      const SizedBox(width: 4),
                      Expanded(child: Text(venue, style: const TextStyle(fontSize: 12, color: AppColors.gray500))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.primaryGold),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('SELECT PASS TIER'.tr('လက်မှတ်အမျိုးအစား ရွေးချယ်ပါ'), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray500)),
                  const SizedBox(height: 10),
                  _buildTierCard(
                    title: 'Standard Admission Pass'.tr('သာမန် ဝင်ခွင့်လက်မှတ်'),
                    desc: 'Full conference keynote access & digital materials'.tr('ဆွေးနွေးပွဲ အပြည့်အစုံ ဝင်ရောက်ခွင့်နှင့် ဒစ်ဂျစ်တယ် စာရွက်စာတမ်းများ'),
                    price: basePrice,
                    isSelected: _selectedTierIndex == 0,
                    onTap: () => setState(() => _selectedTierIndex = 0),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _buildTierCard(
                    title: 'VIP Priority Pass + Lounge'.tr('VIP အထူးဝင်ခွင့်လက်မှတ် + Lounge'),
                    desc: 'Front row seating, VIP networking lunch & speakers lounge'.tr('ရှေ့ဆုံးတန်း ထိုင်ခုံ၊ VIP နေ့လယ်စာနှင့် ဧည့်သည်တော် Lounge'),
                    price: basePrice + 25000,
                    isSelected: _selectedTierIndex == 1,
                    onTap: () => setState(() => _selectedTierIndex = 1),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number of Tickets'.tr('လက်မှတ် အရေအတွက်'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _ticketQuantity > 1 ? () => setState(() => _ticketQuantity--) : null,
                          ),
                          Text('$_ticketQuantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _ticketQuantity < 5 ? () => setState(() => _ticketQuantity++) : null,
                          ),
                        ],
                      ),
                    ],
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable'.tr('စုစုပေါင်း ကျသင့်ငွေ'), style: TextStyle(fontSize: 14, color: AppColors.gray500)),
                      Text(CurrencyFormatter.formatMMK(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  HimoButton(
                    text: 'Confirm Booking'.tr('လက်မှတ်ဝယ်ယူမှု အတည်ပြုမည်'),
                    onPressed: () => _bookEvent(title, venue, date, basePrice),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required String title,
    required String desc,
    required int price,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.12)
              : (isDark ? AppColors.surfaceElevatedDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.borderDark : AppColors.gray200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(CurrencyFormatter.formatMMK(price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }
}

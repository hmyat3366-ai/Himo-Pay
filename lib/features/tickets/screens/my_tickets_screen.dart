import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/ticket_model.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final HimoRepository _repo = HimoRepository();
  int _selectedTab = 0; // 0: Active, 1: Past / Used

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTickets = _repo.tickets;

    final activeTickets = allTickets;
    final pastTickets = [
      TicketModel(
        id: 'PAST-EVT-01',
        title: 'Myanmar Digital Transformation Expo',
        venue: 'Novotel Max Ballroom',
        date: '15 Aug 2026',
        type: TicketType.event,
        code: 'EVT-USED-8821',
        seat: 'General Pass',
      ),
      TicketModel(
        id: 'PAST-MOV-02',
        title: 'Oppenheimer 70mm Re-release',
        venue: 'JCGV Junction Square • Hall 2',
        date: '20 Jul 2026',
        type: TicketType.movie,
        code: 'CIN-USED-4910',
        seat: 'E4, E5',
      ),
    ];

    final displayTickets = _selectedTab == 0 ? activeTickets : pastTickets;

    return Scaffold(
      appBar: HimoAppBar(title: 'My Tickets & Passes'.tr('ကျွန်ုပ်၏ လက်မှတ်များ')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildTab('${'Active'.tr('လက်ရှိ')} (${activeTickets.length})', 0, isDark),
                  const SizedBox(width: 8),
                  _buildTab('${'Past / Used'.tr('အသုံးပြုပြီး')} (${pastTickets.length})', 1, isDark),
                ],
              ),
            ),
            Expanded(
              child: displayTickets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.gray400),
                          const SizedBox(height: 12),
                          Text('No tickets found'.tr('လက်မှတ် မရှိသေးပါ'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: displayTickets.length,
                      itemBuilder: (context, i) {
                        final t = displayTickets[i];
                        final isEvent = t.type == TicketType.event;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HimoCard(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/ticket-detail',
                                arguments: {
                                  'ticket': t,
                                  'isPast': _selectedTab == 1,
                                },
                              );
                            },
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0 ? AppColors.primaryGold : AppColors.gray400,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            isEvent ? 'EVENT PASS'.tr('ပွဲ လက်မှတ်') : 'CINEMA TICKET'.tr('ရုပ်ရှင် လက်မှတ်'),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: _selectedTab == 0 ? AppColors.primaryDark : AppColors.gray500,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: _selectedTab == 0
                                                  ? AppColors.success.withOpacity(0.15)
                                                  : AppColors.gray200,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              _selectedTab == 0 ? 'Active'.tr('လက်ရှိ') : 'Used'.tr('သုံးပြီး'),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: _selectedTab == 0 ? AppColors.success : AppColors.gray500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        t.title,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${t.date} • ${t.venue}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${'Seat:'.tr('ထိုင်ခုံ:')} ${t.seat}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.qr_code_rounded, size: 28, color: AppColors.primaryGold),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int idx, bool isDark) {
    final isSelected = _selectedTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.surfaceElevatedDark : AppColors.gray100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

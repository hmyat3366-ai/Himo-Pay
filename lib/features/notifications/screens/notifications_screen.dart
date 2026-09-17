import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/repositories/himo_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final HimoRepository _repo = HimoRepository();
  int _selectedTab = 0; // 0: All, 1: Payments, 2: Security, 3: Rewards

  @override
  void initState() {
    super.initState();
    _repo.notificationsNotifier.addListener(_onNotifsChanged);
    _repo.fetchFromSupabase();
  }

  void _onNotifsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.notificationsNotifier.removeListener(_onNotifsChanged);
    super.dispose();
  }

  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Received from Wallet',
      'title_my': 'ပိုက်ဆံအိတ်မှ ငွေလက်ခံရရှိ',
      'body': 'You received +32,000 MMK from Thurein Tun. Wallet balance updated.',
      'body_my': 'သူရိန်ထွန်းထံမှ +32,000 MMK လက်ခံရရှိပြီး လက်ကျန်ငွေ ပြောင်းလဲပါပြီ။',
      'time': '10 mins ago',
      'time_my': 'လွန်ခဲ့သော ၁၀ မိနစ်',
      'category': 'Payments',
      'isUnread': true,
      'icon': Icons.arrow_downward_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'Security Login Notice',
      'title_my': 'လုံခြုံရေး ဝင်ရောက်မှု သတိပေးချက်',
      'body': 'Your account was accessed from a new device (iPhone 16 Pro, Yangon).',
      'body_my': 'သင့်အကောင့်ကို စက်ပစ္စည်းအသစ်မှ ဝင်ရောက်ခဲ့သည် (iPhone 16 Pro, Yangon)',
      'time': '2 hours ago',
      'time_my': 'လွန်ခဲ့သော ၂ နာရီ',
      'category': 'Security',
      'isUnread': true,
      'icon': Icons.security_rounded,
      'color': Colors.amber,
    },
    {
      'title': 'Weekend 2X Rewards Active',
      'title_my': 'စနေ/တနင်္ဂနွေ 2X ဆုလာဘ် အထူးအစီအစဉ်',
      'body': 'Earn double points on all QR merchant checkout today!',
      'body_my': 'ယနေ့ ဆိုင်များတွင် QR ဖြင့် ပေးချေတိုင်း ပွိုင့် ၂ ဆ ရယူပါ!',
      'time': 'Yesterday',
      'time_my': 'မနေ့က',
      'category': 'Rewards',
      'isUnread': false,
      'icon': Icons.stars_rounded,
      'color': AppColors.primaryGold,
    },
    {
      'title': 'Bill Payment Cleared',
      'title_my': 'ဘေလ်ပေးချေမှု အောင်မြင်သည်',
      'body': 'YESC Electricity bill payment of 28,500 MMK was successfully settled.',
      'body_my': 'YESC လျှပ်စစ်ဘေလ် 28,500 MMK ပေးချေမှု အောင်မြင်ပါသည်။',
      'time': '2 days ago',
      'time_my': 'လွန်ခဲ့သော ၂ ရက်',
      'category': 'Payments',
      'isUnread': false,
      'icon': Icons.receipt_long_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Biometric Authentication Enabled',
      'title_my': 'လက်ဗွေ/မျက်နှာဖြင့် စစ်ဆေးခြင်း ဖွင့်ထားသည်',
      'body': 'FaceID authentication has been linked to fast app authorization.',
      'body_my': 'လျင်မြန်စွာ အသုံးပြုနိုင်ရန် FaceID ကို ချိတ်ဆက်ပြီးပါပြီ။',
      'time': '5 days ago',
      'time_my': 'လွန်ခဲ့သော ၅ ရက်',
      'category': 'Security',
      'isUnread': false,
      'icon': Icons.fingerprint_rounded,
      'color': Colors.purple,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var n in _notifications) {
        n['isUnread'] = false;
      }
    });
    HimoToast.show(context, 'All notifications marked as read'.tr('အသိပေးချက်များ အားလုံး ဖတ်ပြီးပါပြီ'));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final repoNotifs = _repo.getNotifications().map((n) => {
      'title': n.title,
      'title_my': n.title,
      'body': n.body,
      'body_my': n.body,
      'time': n.time,
      'time_my': n.time,
      'category': n.category,
      'isUnread': !n.isRead,
      'icon': n.type == 'money_received'
          ? Icons.arrow_downward_rounded
          : Icons.arrow_upward_rounded,
      'color': n.type == 'money_received' ? AppColors.success : AppColors.primary,
    }).toList();

    final allNotifs = [...repoNotifs, ..._notifications];

    final filtered = allNotifs.where((n) {
      if (_selectedTab == 1) return n['category'] == 'Payments';
      if (_selectedTab == 2) return n['category'] == 'Security';
      if (_selectedTab == 3) return n['category'] == 'Rewards';
      return true;
    }).toList();

    return Scaffold(
      appBar: HimoAppBar(
        title: 'Notifications'.tr('အသိပေးချက်များ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, size: 22),
            onPressed: _markAllRead,
            tooltip: 'Mark all as read'.tr('အားလုံး ဖတ်ပြီးအဖြစ် သတ်မှတ်မည်'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All'.tr('အားလုံး'), 0, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Payments'.tr('ငွေပေးချေမှု'), 1, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Security'.tr('လုံခြုံရေး'), 2, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Rewards'.tr('ဆုလာဘ်'), 3, isDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await _repo.fetchFromSupabase();
                  if (mounted) setState(() {});
                },
                child: filtered.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                          Center(
                            child: Text(
                              'No notifications yet'.tr('အသိပေးချက် မရှိသေးပါ'),
                              style: const TextStyle(fontSize: 14, color: AppColors.gray500),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final notif = filtered[i];
                          final isUnread = notif['isUnread'] as bool;
                        final title = (notif['title'] as String).tr(notif['title_my'] as String);
                        final body = (notif['body'] as String).tr(notif['body_my'] as String);
                        final time = (notif['time'] as String).tr(notif['time_my'] as String);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HimoCard(
                            onTap: () {
                              setState(() => notif['isUnread'] = false);
                              if (notif['category'] == 'Payments') {
                                Navigator.of(context).pushNamed('/history-all');
                              }
                            },
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (notif['color'] as Color).withOpacity(0.12),
                                  ),
                                  child: Icon(notif['icon'] as IconData, color: notif['color'] as Color, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                                            ),
                                          ),
                                          if (isUnread)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryGold,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        body,
                                        style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        time,
                                        style: const TextStyle(fontSize: 10, color: AppColors.gray400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String title, int idx, bool isDark) {
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

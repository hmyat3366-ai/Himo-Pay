import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/localization/app_strings.dart';

class PromoVouchersScreen extends StatefulWidget {
  const PromoVouchersScreen({super.key});

  @override
  State<PromoVouchersScreen> createState() => _PromoVouchersScreenState();
}

class _PromoVouchersScreenState extends State<PromoVouchersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _location = 'Nationwide';
  String _searchQuery = '';

  final List<String> _tabs = ['All', 'FOOD', 'SERVICES', 'OTHER', 'SHOPPING'];

  // Full voucher data matching AYA format
  final List<Map<String, dynamic>> _allVouchers = [
    // HOT DEALS (All tab featured)
    {
      'name': 'Max Energy',
      'title': 'Max Energy - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'OTHER',
      'color': const Color(0xFFCC0000),
      'letter': 'M',
      'section': 'HOT DEALS',
    },
    {
      'name': 'Max Energy',
      'title': 'Max Energy (Diamond Exclusive) - 15,000 MMK',
      'validUntil': '31/12/2026',
      'points': 150000,
      'category': 'OTHER',
      'color': const Color(0xFFCC0000),
      'letter': 'M',
      'section': 'HOT DEALS',
    },
    {
      'name': 'City Mart',
      'title': 'CMHL - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SHOPPING',
      'color': const Color(0xFFFFB300),
      'letter': 'C',
      'section': 'HOT DEALS',
    },
    {
      'name': 'PRO1 Global',
      'title': 'PRO 1 Global Home Center - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SHOPPING',
      'color': const Color(0xFFE53935),
      'letter': 'P',
      'section': 'HOT DEALS',
    },
    {
      'name': 'Makro',
      'title': 'Makro Myanmar - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SHOPPING',
      'color': const Color(0xFFD32F2F),
      'letter': 'M',
      'section': 'HOT DEALS',
    },
    // FOOD
    {
      'name': 'MU Pork Salad',
      'title': 'MU PORK SALAD - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFFE57373),
      'letter': 'M',
      'section': 'FOOD',
    },
    {
      'name': 'Sone See Yar',
      'title': 'SONE SEE YAR - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFF7B8D7A),
      'letter': 'S',
      'section': 'FOOD',
    },
    {
      'name': 'Natural Life',
      'title': 'NATURAL LIFE - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFF4CAF50),
      'letter': 'N',
      'section': 'FOOD',
    },
    {
      'name': 'The Village',
      'title': 'The Village - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFF607D8B),
      'letter': 'V',
      'section': 'FOOD',
    },
    {
      'name': 'Five Star PPN',
      'title': 'FIVE STAR PPN - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFFF44336),
      'letter': 'F',
      'section': 'FOOD',
    },
    {
      'name': 'Shwe Wutt Yee Tea Shop',
      'title': 'SHWE WUTT YEE TEA SHOP - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'FOOD',
      'color': const Color(0xFF795548),
      'letter': 'S',
      'section': 'FOOD',
    },
    {
      'name': 'Shyam Sweets',
      'title': 'SHYAM SWEETS (Diamond Exclusive)',
      'validUntil': '31/12/2026',
      'points': 100000,
      'category': 'FOOD',
      'color': const Color(0xFFD32F2F),
      'letter': 'S',
      'section': 'FOOD',
    },
    {
      'name': 'Ya Kun Cafe',
      'title': 'Ya Kun Cafe - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 15000,
      'category': 'FOOD',
      'color': const Color(0xFF8B1A1A),
      'letter': 'Y',
      'section': 'FOOD',
    },
    {
      'name': "Cheese O'Tea",
      'title': "Cheese O'Tea - 3,000 MMK",
      'validUntil': '31/12/2026',
      'points': 15000,
      'category': 'FOOD',
      'color': const Color(0xFF212121),
      'letter': 'C',
      'section': 'FOOD',
    },
    {
      'name': 'ChaTraMue',
      'title': 'ChaTraMue - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 15000,
      'category': 'FOOD',
      'color': const Color(0xFF8B0000),
      'letter': 'C',
      'section': 'FOOD',
    },
    {
      'name': 'Potato Corner',
      'title': 'POTATO CORNER - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 15000,
      'category': 'FOOD',
      'color': const Color(0xFF2E7D32),
      'letter': 'P',
      'section': 'FOOD',
    },
    {
      'name': 'Thae Lay Coffee',
      'title': 'Thae Lay Coffee - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 15000,
      'category': 'FOOD',
      'color': const Color(0xFF4E342E),
      'letter': 'T',
      'section': 'FOOD',
    },
    // SERVICES (Hotels)
    {
      'name': 'Akariz Hotel',
      'title': 'AKARIZ HOTEL - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SERVICES',
      'color': const Color(0xFFB8860B),
      'letter': 'A',
      'section': 'SERVICES',
    },
    {
      'name': 'ibis Styles Mandalay',
      'title': 'ibis Style Mandalay (Diamond Exclusive)',
      'validUntil': '31/12/2026',
      'points': 100000,
      'category': 'SERVICES',
      'color': const Color(0xFF388E3C),
      'letter': 'I',
      'section': 'SERVICES',
    },
    {
      'name': 'Ease Hotel',
      'title': 'EASE HOTEL (Diamond Exclusive)',
      'validUntil': '31/12/2026',
      'points': 100000,
      'category': 'SERVICES',
      'color': const Color(0xFF5C6BC0),
      'letter': 'E',
      'section': 'SERVICES',
    },
    {
      'name': 'White House Hotel',
      'title': 'WHITE HOUSE HOTEL (Diamond Exclusive)',
      'validUntil': '31/12/2026',
      'points': 100000,
      'category': 'SERVICES',
      'color': const Color(0xFF37474F),
      'letter': 'W',
      'section': 'SERVICES',
    },
    {
      'name': 'Tungapuri Hotel',
      'title': 'TUNGAPURI HOTEL (Diamond Exclusive)',
      'validUntil': '31/12/2026',
      'points': 100000,
      'category': 'SERVICES',
      'color': const Color(0xFF1B5E20),
      'letter': 'T',
      'section': 'SERVICES',
    },
    // OTHER (Petrol/Energy)
    {
      'name': 'Dollar Oil Mill',
      'title': 'DOLLAR OIL MILL - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'OTHER',
      'color': const Color(0xFFFFAB00),
      'letter': 'D',
      'section': 'OTHER',
    },
    {
      'name': 'Moon Sun Energy',
      'title': 'Moon Sun Energy - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'OTHER',
      'color': const Color(0xFF1565C0),
      'letter': 'M',
      'section': 'OTHER',
    },
    {
      'name': 'PT Power',
      'title': 'PT POWER - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'OTHER',
      'color': const Color(0xFF2E7D32),
      'letter': 'P',
      'section': 'OTHER',
    },
    {
      'name': 'U Thaung Sein Energy',
      'title': 'U Thaung Sein Energy - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'OTHER',
      'color': const Color(0xFFB8860B),
      'letter': 'U',
      'section': 'OTHER',
    },
    {
      'name': 'Regency Petrol Station',
      'title': 'REGENCY Petrol Station - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'OTHER',
      'color': const Color(0xFF1565C0),
      'letter': 'R',
      'section': 'OTHER',
    },
    {
      'name': 'Terminal Petrol Station',
      'title': 'TERMINAL Petrol Station - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'OTHER',
      'color': const Color(0xFF33691E),
      'letter': 'T',
      'section': 'OTHER',
    },
    // SHOPPING
    {
      'name': 'Seindaung Superstore',
      'title': 'SEINDAUNG SUPERSTORE - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SHOPPING',
      'color': const Color(0xFFD32F2F),
      'letter': 'S',
      'section': 'SHOPPING',
    },
    {
      'name': 'Blue Sea Mini Mart',
      'title': 'BLUE SEA MINI MART - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'SHOPPING',
      'color': const Color(0xFF1565C0),
      'letter': 'B',
      'section': 'SHOPPING',
    },
    {
      'name': 'Shwe Zalat Wah',
      'title': 'Shwe Zalat Wah - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'SHOPPING',
      'color': const Color(0xFFE91E63),
      'letter': 'S',
      'section': 'SHOPPING',
    },
    {
      'name': 'Golden Island',
      'title': 'Golden Island - 3,000 MMK',
      'validUntil': '31/12/2026',
      'points': 30000,
      'category': 'SHOPPING',
      'color': const Color(0xFF2E7D32),
      'letter': 'G',
      'section': 'SHOPPING',
    },
    {
      'name': 'Lewe Superstore',
      'title': 'LEWE SUPERSTORE - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'category': 'SHOPPING',
      'color': const Color(0xFF00BCD4),
      'letter': 'L',
      'section': 'SHOPPING',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchCtrl.addListener(() => setState(() => _searchQuery = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVouchers {
    final tab = _tabs[_tabController.index];
    return _allVouchers.where((v) {
      final matchTab = tab == 'All' || v['category'] == tab;
      final matchSearch = _searchQuery.isEmpty ||
          (v['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (v['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  String get _sectionHeader {
    final tab = _tabs[_tabController.index];
    if (tab == 'All') return 'HOT DEALS';
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vouchers = _filteredVouchers;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
      appBar: HimoAppBar(
        title: 'Promo Vouchers'.tr('ပရိုမိုးရှင်း ဘောက်ချာများ'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.confirmation_num_outlined,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            label: Text(
              'My Vouchers'.tr('ကျွန်ုပ်၏ ဘောက်ချာများ'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Search + Location row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                // Search field
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : const Color(0xFFDDDDDD),
                      ),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search'.tr('ရှာဖွေမည်'),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white38 : Colors.grey[400],
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark ? Colors.white38 : Colors.grey[400],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Location dropdown
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFDDDDDD),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _location,
                      isDense: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      items: ['Nationwide', 'Yangon', 'Mandalay', 'Naypyidaw']
                          .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                          .toList(),
                      onChanged: (val) => setState(() => _location = val!),
                      selectedItemBuilder: (context) => [
                        'Nationwide', 'Yangon', 'Mandalay', 'Naypyidaw'
                      ]
                          .map((loc) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 14, color: AppColors.gray500),
                                  const SizedBox(width: 4),
                                  Text(loc),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // ── Category Tabs ──
          Container(
            color: isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: isDark ? Colors.white54 : Colors.black54,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              indicatorColor: AppColors.primaryGold,
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // ── Voucher List ──
          Expanded(
            child: vouchers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.confirmation_num_outlined, size: 64, color: AppColors.gray300),
                        const SizedBox(height: 12),
                        Text(
                          'No vouchers found'.tr('ဘောက်ချာ မရှိသေးပါ'),
                          style: TextStyle(color: AppColors.gray500, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Section header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _sectionHeader,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isDark ? AppColors.borderDark : const Color(0xFFDDDDDD),
                                  ),
                                ),
                              ),
                              child: Text(
                                'See all'.tr('အားလုံးကြည့်ရန်'),
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...vouchers.map((v) => _buildVoucherItem(v, isDark)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherItem(Map<String, dynamic> v, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/voucher-detail',
          arguments: {
            'title': v['title'],
            'partner': v['name'],
            'costPts': ((v['points'] as int) ~/ 100),
            'validUntil': v['validUntil'],
          },
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Brand logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (v['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: (v['color'] as Color).withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    v['letter'] as String,
                    style: TextStyle(
                      color: v['color'] as Color,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Title + validity
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v['title'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'Valid until'.tr('သက်တမ်းကုန်ဆုံးရက်')} ${v['validUntil']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00A86B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Points badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGold, width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        'P',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPoints(v['points'] as int),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Points'.tr('ရမှတ်'),
                    style: TextStyle(fontSize: 11, color: AppColors.gray500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPoints(int pts) {
    if (pts >= 1000) {
      final k = pts ~/ 1000;
      return '${k}000';
    }
    return pts.toString();
  }
}

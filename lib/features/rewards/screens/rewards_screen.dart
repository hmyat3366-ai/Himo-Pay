import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../core/localization/app_strings.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final HimoRepository _repo = HimoRepository();
  int _currentTierIndex = 1; // default Silver

  // Tier data – Luxury dark metallic VIP cards inspired by elite card aesthetic
  final List<Map<String, dynamic>> _tiers = [
    {
      'name': 'Bronze',
      'level': 'VIP 1',
      'subtitle': 'Warm Bronze • Essential Privileges',
      'accentColor': const Color(0xFFD49B6A),
      'gradient': const [Color(0xFF2A1C14), Color(0xFF160E0A), Color(0xFF0C0806)],
      'locked': false,
      'desc': 'Access to discounts, promotions, and offers available to Bronze tier.',
      'progress': 0.85,
      'nextPts': '500',
    },
    {
      'name': 'Silver',
      'level': 'VIP 2',
      'subtitle': 'Refined Silver • Priority Access',
      'accentColor': const Color(0xFFD8DDE6),
      'gradient': const [Color(0xFF22262E), Color(0xFF13161B), Color(0xFF0B0D10)],
      'locked': true,
      'desc': 'Access to discounts, promotions, and offers available to Silver tier.',
      'progress': 0.45,
      'nextPts': '3,500',
    },
    {
      'name': 'Gold',
      'level': 'VIP 3',
      'subtitle': 'Himo Gold • Elite Recognition',
      'accentColor': const Color(0xFFE5C17D),
      'gradient': const [Color(0xFF2C2214), Color(0xFF171109), Color(0xFF0C0905)],
      'locked': true,
      'desc': 'Access to discounts, promotions, and offers available to Gold tier.',
      'progress': 0.15,
      'nextPts': '10,000',
    },
    {
      'name': 'Platinum',
      'level': 'VIP 4',
      'subtitle': 'Obsidian Platinum • Supreme Privileges',
      'accentColor': const Color(0xFFA5B4FC),
      'gradient': const [Color(0xFF181A22), Color(0xFF0D0E14), Color(0xFF060709)],
      'locked': true,
      'desc': 'Access to discounts, promotions, and offers available to Platinum tier.',
      'progress': 0.05,
      'nextPts': '50,000',
    },
  ];

  // Latest rewards list matching partner vouchers
  final List<Map<String, dynamic>> _latestRewards = [
    {
      'name': 'Max Energy',
      'title': 'Max Energy - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'color': const Color(0xFFCC0000),
      'letter': 'M',
    },
    {
      'name': 'Max Energy',
      'title': 'Max Energy (Diamond Exclusive) - 15,000 MMK',
      'validUntil': '31/12/2026',
      'points': 150000,
      'color': const Color(0xFFCC0000),
      'letter': 'M',
    },
    {
      'name': 'City Mart',
      'title': 'City Mart Supermarket - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'color': const Color(0xFFFFB300),
      'letter': 'C',
    },
    {
      'name': 'PRO1 Global',
      'title': 'PRO 1 Global Home Center - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'color': const Color(0xFFE53935),
      'letter': 'P',
    },
    {
      'name': 'Makro',
      'title': 'Makro Myanmar - 5,000 MMK',
      'validUntil': '31/12/2026',
      'points': 50000,
      'color': const Color(0xFFD32F2F),
      'letter': 'M',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final points = _repo.points;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text(
          'My Himo Points'.tr('ကျွန်ုပ်၏ Himo ရမှတ်များ'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/points-history'),
            icon: Icon(
              Icons.history_rounded,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            label: Text(
              'History'.tr('မှတ်တမ်း'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 8),

            // ── Tier Cards Carousel ──
            SizedBox(
              height: 224,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.88, initialPage: _currentTierIndex),
                itemCount: _tiers.length,
                onPageChanged: (idx) => setState(() => _currentTierIndex = idx),
                itemBuilder: (context, i) {
                  final t = _tiers[i];
                  final isLocked = t['locked'] as bool;
                  return _buildTierCard(t, isLocked, isDark, points);
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Nano Banners: Promo Vouchers & Secret Shop ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildNanoBanner(
                    title: 'Promo Vouchers'.tr('ပရိုမိုးရှင်း ဘောက်ချာများ'),
                    tag: 'POINTS DISCOUNT'.tr('ရမှတ် လျှော့စျေး'),
                    desc: 'Redeem your points for dining, shopping & brand discount vouchers up to 50% OFF.'.tr('ရမှတ်များဖြင့် စားသောက်ဆိုင်၊ ဈေးဝယ်နှင့် အမှတ်တံဆိပ် ၅၀% အထိ လျှော့စျေး ဘောက်ချာများ လဲလှယ်ပါ'),
                    icon: Icons.confirmation_number_rounded,
                    accentColor: AppColors.primaryGold,
                    gradient: const [
                      Color(0xFF261D12),
                      Color(0xFF15110B),
                    ],
                    onTap: () => Navigator.of(context).pushNamed('/promo-vouchers'),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildNanoBanner(
                    title: 'Secret Shop'.tr('လျှို့ဝှက် အရောင်းဆိုင်'),
                    tag: 'VIP EXCLUSIVE'.tr('VIP သီးသန့်'),
                    desc: 'Exclusive high-tier member perks, limited gifts & rare physical rewards.'.tr('အဆင့်မြင့် အသင်းဝင်များအတွက် သီးသန့်ခံစားခွင့်၊ ကန့်သတ်လက်ဆောင်များနှင့် လက်ဆောင်ပစ္စည်းများ'),
                    icon: Icons.redeem_rounded,
                    accentColor: const Color(0xFFA78BFA),
                    gradient: const [
                      Color(0xFF1D1A2E),
                      Color(0xFF0F0E18),
                    ],
                    onTap: () => Navigator.of(context).pushNamed('/secret-shop'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Latest Rewards ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Rewards'.tr('နောက်ဆုံးရ ရမှတ်ဆုများ'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/promo-vouchers'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200),
                      ),
                    ),
                    child: Text(
                      'See all'.tr('အားလုံးကြည့်ရန်'),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Reward list
            ...List.generate(_latestRewards.length, (i) {
              final r = _latestRewards[i];
              return _buildRewardItem(r, isDark, i);
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard(Map<String, dynamic> t, bool isLocked, bool isDark, int points) {
    final accent = t['accentColor'] as Color;
    final gradient = t['gradient'] as List<Color>;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: accent.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: accent.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Sci-fi orbital / black hole luxury watermark inspired by Image 2
            Positioned.fill(
              child: CustomPaint(
                painter: LuxuryOrbWatermarkPainter(accentColor: accent),
              ),
            ),

            // Diagonal metallic sheen overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                      Colors.black.withOpacity(0.25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Card Foreground Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Monogram Emblem Logo & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLuxuryLogo(accent),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: accent.withOpacity(0.4), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              !isLocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
                              size: 12,
                              color: accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              !isLocked ? 'CURRENT TIER'.tr('လက်ရှိအဆင့်') : 'LOCKED'.tr('မဖွင့်သေးပါ'),
                              style: TextStyle(
                                color: accent,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Progress Bar & Points to Next Level
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            !isLocked
                                ? 'Tier Progress'.tr('အဆင့်တက်ရန် တိုးတက်မှု')
                                : '${'Next Tier Requirement: '.tr('နောက်အဆင့် လိုအပ်ချက် - ')}${t['nextPts']} Pts',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            '${((t['progress'] as double) * 100).toInt()}%',
                            style: TextStyle(
                              color: accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: t['progress'] as double,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(accent),
                          minHeight: 2.5,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: VIP Typography & Action Chips
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tier Title & Subtitle (matching the VIP title look in sample image)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${t['name'].toString().toUpperCase()} VIP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                height: 1.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              t['subtitle'] as String,
                              style: TextStyle(
                                color: accent.withOpacity(0.85),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Action Chips (Details & Tier Benefits)
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _luxuryTierBtn(
                                icon: Icons.info_outline_rounded,
                                label: 'Details'.tr('အသေးစိတ်'),
                                accent: accent,
                                onTap: () => _showTierDetailModal(context, t, isLocked, isDark),
                              ),
                              const SizedBox(width: 6),
                              _luxuryTierBtn(
                                icon: Icons.chevron_right_rounded,
                                label: 'Benefits'.tr('ခံစားခွင့်များ'),
                                accent: accent,
                                trailing: true,
                                onTap: () => Navigator.of(context).pushNamed('/tier-benefits'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryLogo(Color accent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.35),
                accent.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: accent.withOpacity(0.5), width: 1),
          ),
          child: Center(
            child: Icon(
              Icons.grain_rounded,
              color: accent,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'HIMO CLUB',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              'PRIVILEGE STATUS',
              style: TextStyle(
                color: accent.withOpacity(0.8),
                fontSize: 7.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _luxuryTierBtn({
    required IconData icon,
    required String label,
    required Color accent,
    required VoidCallback onTap,
    bool trailing = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!trailing) Icon(icon, color: Colors.white.withOpacity(0.9), size: 12),
            if (!trailing) const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
            if (trailing) const SizedBox(width: 2),
            if (trailing) Icon(icon, color: Colors.white.withOpacity(0.9), size: 13),
          ],
        ),
      ),
    );
  }

  Widget _buildNanoBanner({
    required String title,
    required String tag,
    required String desc,
    required IconData icon,
    required Color accentColor,
    required List<Color> gradient,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? gradient
                : [
                    Colors.white,
                    const Color(0xFFF9FAFB),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDark
                ? accentColor.withOpacity(0.25)
                : AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Visual Artwork Container with badge icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.25),
                    accentColor.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: accentColor.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(Icons.auto_awesome, color: accentColor.withOpacity(0.6), size: 9),
                  ),
                  Icon(
                    icon,
                    color: accentColor,
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Content: Title, Tag, and Purpose explanation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action Arrow Cue
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : const Color(0xFFF3F4F6),
                border: Border.all(
                  color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                ),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 15,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTierDetailModal(BuildContext context, Map<String, dynamic> t, bool isLocked, bool isDark) {
    final accent = t['accentColor'] as Color;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1D24) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accent.withOpacity(0.35), accent.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: accent.withOpacity(0.6), width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.military_tech_rounded,
                    color: accent,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${t['name']} ${'VIP Tier Privileges'.tr('VIP အဆင့် အထူးအခွင့်အရေးများ')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t['subtitle'] as String,
                style: TextStyle(
                  fontSize: 12.5,
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF242733) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  children: [
                    _modalInfoRow('Status'.tr('အခြေအနေ'), !isLocked ? 'Active Tier'.tr('လက်ရှိအဆင့်') : 'Locked'.tr('မဖွင့်သေးပါ'), isDark, accent: accent),
                    const Divider(height: 18),
                    _modalInfoRow('Unlock Requirement'.tr('ဖွင့်ရန် လိုအပ်ချက်'), '${t['nextPts']} ${'Himo Points'.tr('Himo ရမှတ်')}', isDark),
                    const Divider(height: 18),
                    _modalInfoRow('Transfer Fee Discount'.tr('ငွေလွှဲခ လျှော့စျေး'), (t['progress'] as double) > 0.5 ? '100% Free'.tr('၁၀၀% အခမဲ့') : '50% Off'.tr('၅၀% လျှော့'), isDark),
                    const Divider(height: 18),
                    _modalInfoRow('Voucher Redemptions'.tr('ဘောက်ချာ လဲလှယ်မှု'), 'Unlimited Access'.tr('အကန့်အသတ်မရှိ'), isDark),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).pushNamed('/tier-benefits');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: accent.withOpacity(0.5)),
                      ),
                      child: Text(
                        'All Benefits'.tr('ခံစားခွင့် အားလုံး'),
                        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1F2937), fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Close'.tr('ပိတ်မည်'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _modalInfoRow(String label, String value, bool isDark, {Color? accent}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.gray400 : const Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: accent ?? (isDark ? Colors.white : const Color(0xFF111827)),
          ),
        ),
      ],
    );
  }

  Widget _buildRewardItem(Map<String, dynamic> r, bool isDark, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE)),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          '/voucher-detail',
          arguments: {
            'title': r['title'],
            'partner': r['name'],
            'costPts': ((r['points'] as int) ~/ 100),
            'validUntil': r['validUntil'],
          },
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Brand logo placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (r['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: (r['color'] as Color).withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    r['letter'] as String,
                    style: TextStyle(
                      color: r['color'] as Color,
                      fontSize: 24,
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
                      r['title'] as String,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'Valid until'.tr('သက်တမ်းကုန်ဆုံးရက်')} ${r['validUntil']}',
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPoints(r['points'] as int),
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
    if (pts >= 1000) return '${(pts / 1000).toStringAsFixed(0)}000';
    return pts.toString();
  }
}

class LuxuryOrbWatermarkPainter extends CustomPainter {
  final Color accentColor;

  const LuxuryOrbWatermarkPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.76, size.height * 0.48);
    final radius = size.height * 0.54;

    // Soft dark radial glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentColor.withOpacity(0.14),
          accentColor.withOpacity(0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));
    canvas.drawCircle(center, radius * 1.4, glowPaint);

    // Primary tilted orbital ring (like Saturn / Black Hole ring in sample image)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.36); // Tilted ~21 degrees

    // Outer faint ring
    final faintRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.08);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 2.35, height: radius * 1.05),
      faintRingPaint,
    );

    // Concentric dotted / mesh ring
    final meshRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = accentColor.withOpacity(0.22);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 1.95, height: radius * 0.86),
      meshRingPaint,
    );

    // Glowing primary arc ring
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..shader = LinearGradient(
        colors: [
          accentColor.withOpacity(0.85),
          accentColor.withOpacity(0.25),
          Colors.transparent,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromCenter(center: Offset.zero, width: radius * 1.95, height: radius * 0.86));
    canvas.drawArc(
      Rect.fromCenter(center: Offset.zero, width: radius * 1.95, height: radius * 0.86),
      -1.2,
      2.6,
      false,
      arcPaint,
    );

    // Inner orbital line
    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Colors.white.withOpacity(0.06);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: radius * 1.45, height: radius * 0.62),
      innerRingPaint,
    );

    // Inner glowing core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black.withOpacity(0.65),
          Colors.black.withOpacity(0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius * 0.45));
    canvas.drawCircle(Offset.zero, radius * 0.45, corePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LuxuryOrbWatermarkPainter oldDelegate) =>
      oldDelegate.accentColor != accentColor;
}

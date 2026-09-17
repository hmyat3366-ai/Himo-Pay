import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';

class WalletDealsScreen extends StatefulWidget {
  const WalletDealsScreen({super.key});

  @override
  State<WalletDealsScreen> createState() => _WalletDealsScreenState();
}

class _WalletDealsScreenState extends State<WalletDealsScreen> {
  String _activeTab = 'deals'; // deals, refunded

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'My Deals'.tr('ကျွန်ုပ်၏ လျှော့ဈေးများ')),
      body: SafeArea(
        child: Column(
          children: [
            // Top Toggle Pill
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTab('deals', 'My Deals'.tr('ကျွန်ုပ်၏ လျှော့ဈေးများ'), isDark),
                  _buildTab('refunded', 'Refunded Deals'.tr('ပြန်အမ်းငွေ လျှော့ဈေးများ'), isDark),
                ],
              ),
            ),

            const Spacer(),

            // Empty state
            Icon(Icons.receipt_outlined, size: 72, color: isDark ? AppColors.gray500 : AppColors.gray300),
            const SizedBox(height: 16),
            Text(
              _activeTab == 'deals' ? 'There is no deals.'.tr('လျှော့ဈေး မရှိသေးပါ') : 'No Refunded Deals found.'.tr('ပြန်အမ်းငွေ လျှော့ဈေး မရှိပါ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.gray700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore group deals & merchant vouchers at partner cafes.',
              style: TextStyle(fontSize: 13, color: AppColors.gray500),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: HimoButton(
                text: 'Add Deals Now',
                isPrimary: false,
                onPressed: () => Navigator.of(context).pushNamed('/deals'),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String id, String label, bool isDark) {
    final isSelected = _activeTab == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? AppColors.black : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? (isDark ? Colors.white : AppColors.gray900) : AppColors.gray500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../data/repositories/himo_repository.dart';

class WalletVouchersScreen extends StatefulWidget {
  const WalletVouchersScreen({super.key});

  @override
  State<WalletVouchersScreen> createState() => _WalletVouchersScreenState();
}

class _WalletVouchersScreenState extends State<WalletVouchersScreen> {
  final HimoRepository _repo = HimoRepository();
  String _activeSubTab = 'active'; // active, used, expired

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allVouchers = _repo.getVouchers();
    final activeList = allVouchers.where((v) => v.isClaimed).toList();

    return Scaffold(
      appBar: HimoAppBar(title: 'My Vouchers'.tr('ကျွန်ုပ်၏ ကူပွန်များ')),
      body: SafeArea(
        child: Column(
          children: [
            // Sub-tabs: Active | Used | Expired
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildSubTab('active', '${'Active'.tr('လက်ရှိ')} (2)', isDark),
                  _buildSubTab('used', '${'Used'.tr('သုံးပြီး')} (0)', isDark),
                  _buildSubTab('expired', '${'Expired'.tr('သက်တမ်းကုန်')} (0)', isDark),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: _activeSubTab == 'active'
                  ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: activeList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final v = activeList[index];
                        return HimoCard(
                          onTap: () {
                            Navigator.of(context).pushNamed('/voucher-detail', arguments: v);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.percent, color: AppColors.primary, size: 22),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      v.title,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Valid: ${v.validity}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Code: ${v.code}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 18, color: AppColors.gray400),
                                onPressed: () {
                                  HimoToast.show(context, 'Voucher code ${v.code} copied!');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: isDark ? AppColors.gray500 : AppColors.gray300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _activeSubTab == 'used' ? 'No Used Vouchers' : 'No Expired Vouchers',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Earn more vouchers with Himo Rewards points.',
                            style: TextStyle(fontSize: 13, color: AppColors.gray500),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTab(String id, String label, bool isDark) {
    final isSelected = _activeSubTab == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeSubTab = id),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? AppColors.black : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
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

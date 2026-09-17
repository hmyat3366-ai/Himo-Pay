import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HimoRepository _repo = HimoRepository();
  int _selectedFilter = 0; // 0: All, 1: Money In, 2: Money Out, 3: Bills & Top Up
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo.transactionsNotifier.addListener(_onTransactionsChanged);
    _repo.fetchFromSupabase();
  }

  void _onTransactionsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.transactionsNotifier.removeListener(_onTransactionsChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    AppPreferences.triggerHaptic(HapticType.light);
    await _repo.fetchFromSupabase();
    if (mounted) {
      setState(() {});
      HimoToast.show(context, 'History updated'.tr('မှတ်တမ်းများ အသစ်ရရှိပါပြီ'));
    }
  }


  void _showDetail(TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                tx.title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                (tx.type == TransactionType.inMoney ? '+ ' : '- ') +
                    CurrencyFormatter.formatMMK(tx.amount),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: tx.type == TransactionType.inMoney ? AppColors.success : (isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              HimoCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildModalRow('Transaction ID'.tr('လွှဲပြောင်းမှု ID'), tx.id, isDark),
                    const Divider(height: 16),
                    _buildModalRow('Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), tx.date, isDark),
                    const Divider(height: 16),
                    _buildModalRow('Category'.tr('အမျိုးအစား'), tx.category, isDark),
                    const Divider(height: 16),
                    _buildModalRow('Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), isDark, valueColor: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        HimoToast.show(context, 'Receipt image saved to gallery'.tr('ပြေစာကို သိမ်းဆည်းပြီးပါပြီ'));
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: Text('Share Receipt'.tr('ပြေစာ မျှဝေမည်')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Close'.tr('ပိတ်မည်'), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
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

  Widget _buildModalRow(String label, String value, bool isDark, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTxs = _repo.transactions;

    final query = _searchController.text.trim().toLowerCase();
    final filtered = allTxs.where((tx) {
      if (query.isNotEmpty && !tx.title.toLowerCase().contains(query)) {
        return false;
      }
      if (_selectedFilter == 1) return tx.type == TransactionType.inMoney;
      if (_selectedFilter == 2) return tx.type == TransactionType.outMoney;
      if (_selectedFilter == 3) return tx.category == 'Utility Bill' || tx.category == 'Top Up';
      return true;
    }).toList();

    return Scaffold(
      appBar: HimoAppBar(title: 'Transaction History'.tr('ငွေလွှဲမှတ်တမ်း')),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search transactions...'.tr('မှတ်တမ်းများ ရှာဖွေရန်...'),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.gray500),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip('All'.tr('အားလုံး'), 0, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Money In'.tr('ရငွေ'), 1, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Money Out'.tr('သုံးငွေ'), 2, isDark),
                    const SizedBox(width: 8),
                    _buildChip('Bills & Top Up'.tr('ဘေလ်နှင့် ဖုန်းငွေဖြည့်'), 3, isDark),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.primaryGold,
                child: filtered.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: 350,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.gray400),
                              const SizedBox(height: 12),
                              Text('No transactions match your filter'.tr('မှတ်တမ်း မရှိသေးပါ'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final tx = filtered[i];
                          final isIn = tx.type == TransactionType.inMoney;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: HimoCard(
                              onTap: () => _showDetail(tx),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isIn
                                          ? AppColors.success.withOpacity(0.12)
                                          : (isDark ? AppColors.surfaceDark : AppColors.gray100),
                                    ),
                                    child: Icon(
                                      isIn ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                      color: isIn ? AppColors.success : (isDark ? Colors.white70 : Colors.black87),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.title,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${tx.date} • ${tx.category}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.gray500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    (isIn ? '+ ' : '- ') + CurrencyFormatter.formatMMK(tx.amount),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isIn ? AppColors.success : (isDark ? Colors.white : Colors.black),
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
    final isSelected = _selectedFilter == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.surfaceElevatedDark : AppColors.gray100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : (isDark ? AppColors.borderDark : AppColors.gray200),
          ),
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

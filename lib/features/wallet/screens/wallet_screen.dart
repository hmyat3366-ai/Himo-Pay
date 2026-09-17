import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/storage/app_preferences.dart';
import '../../../data/repositories/himo_repository.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final HimoRepository _repo = HimoRepository();

  @override
  void initState() {
    super.initState();
    _repo.walletNotifier.addListener(_onWalletDataChanged);
  }

  void _onWalletDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.walletNotifier.removeListener(_onWalletDataChanged);
    super.dispose();
  }

  Future<void> _onRefresh() async {
    AppPreferences.triggerHaptic(HapticType.light);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) {
      setState(() {});
      HimoToast.show(context, 'Wallet refreshed'.tr('ပိုက်ဆံအိတ် အသစ်ရရှိပါပြီ'));
    }
  }


  @override
  Widget build(BuildContext context) {
    final wallet = _repo.getWallet();

    return Scaffold(
      appBar: HimoAppBar(title: AppStrings.myWallet, showBack: false),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Balance Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.cardBorder,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E242E), Color(0xFF11151C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.totalBalance,
                          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => _repo.toggleBalanceVisibility());
                          },
                          child: Icon(
                            wallet.isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      wallet.isBalanceHidden ? '•••••• MMK' : wallet.formattedBalance,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Himo Rewards Loyalty'.tr('Himo ဆုလာဘ် အစီအစဉ်'),
                          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          '${wallet.points} ${'Points Available'.tr('ပွိုင့် ရရှိနိုင်ပါသည်')}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Wallet Management Group
              Text('Management & Assets'.tr('စီမံခန့်ခွဲမှုနှင့် ပိုင်ဆိုင်မှုများ'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              HimoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildWalletMenuItem(
                      icon: Icons.account_balance,
                      title: AppStrings.linkedBankAccounts,
                      subtitle: 'KBZ Bank • Connected'.tr('KBZ ဘဏ် • ချိတ်ဆက်ထားသည်'),
                      onTap: () => Navigator.of(context).pushNamed('/wallet-bank-accounts'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildWalletMenuItem(
                      icon: Icons.credit_card,
                      title: AppStrings.linkedCards,
                      subtitle: 'Visa •••• 4242',
                      onTap: () => Navigator.of(context).pushNamed('/wallet-cards'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildWalletMenuItem(
                      icon: Icons.discount_outlined,
                      title: AppStrings.myVouchers,
                      subtitle: '3 Active discount codes'.tr('ကူပွန် ၃ ခု ရရှိနိုင်ပါသည်'),
                      onTap: () => Navigator.of(context).pushNamed('/wallet-vouchers'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildWalletMenuItem(
                      icon: Icons.local_offer_outlined,
                      title: AppStrings.activeGroupDeals,
                      subtitle: 'Promotional merchant deals'.tr('မိတ်ဖက်ဆိုင်များ၏ လျှော့ဈေးများ'),
                      onTap: () => Navigator.of(context).pushNamed('/wallet-deals'),
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildWalletMenuItem(
                      icon: Icons.workspace_premium_outlined,
                      title: AppStrings.tierBenefits,
                      subtitle: 'Subscriber Level 2 perks'.tr('Level 2 အထူးအခွင့်အရေးများ'),
                      onTap: () => Navigator.of(context).pushNamed('/tier-benefits'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Quick Deposit & Withdraw row
              Row(
                children: [
                  Expanded(
                    child: HimoCard(
                      onTap: () => Navigator.of(context).pushNamed('/cashin-methods'),
                      child: Column(
                        children: [
                          const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
                          const SizedBox(height: 8),
                          Text(AppStrings.cashIn, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('Top-up wallet'.tr('ပိုက်ဆံအိတ်ထဲ ငွေထည့်မည်'), style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HimoCard(
                      onTap: () => Navigator.of(context).pushNamed('/cashout-methods'),
                      child: Column(
                        children: [
                          const Icon(Icons.arrow_circle_up_outlined, color: AppColors.primary, size: 28),
                          const SizedBox(height: 8),
                          Text(AppStrings.cashOut, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('Withdraw to Bank'.tr('ဘဏ်သို့ ငွေထုတ်မည်'), style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildWalletMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gray400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/widgets/language_selection_modal.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/localization/locale_manager.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/mock/mock_data.dart';
import '../../../core/storage/app_preferences.dart';
import '../widgets/himo_debit_wallet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HimoRepository _repo = HimoRepository();
  String _selectedMainTab = 'history'; // 'history', 'whats_up'

  @override
  void initState() {
    super.initState();
    _repo.walletNotifier.addListener(_onWalletDataChanged);
    _repo.transactionsNotifier.addListener(_onWalletDataChanged);
    _repo.userNotifier.addListener(_onWalletDataChanged);
    _repo.fetchFromSupabase();
  }

  void _onWalletDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _repo.walletNotifier.removeListener(_onWalletDataChanged);
    _repo.transactionsNotifier.removeListener(_onWalletDataChanged);
    _repo.userNotifier.removeListener(_onWalletDataChanged);
    super.dispose();
  }

  void _toggleLanguage() {
    LanguageSelectionModal.show(context);
  }

  void _toggleBalance() {
    setState(() {
      _repo.toggleBalanceVisibility();
    });
  }

  Future<void> _onRefresh() async {
    AppPreferences.triggerHaptic(HapticType.light);
    await _repo.fetchFromSupabase();
    if (mounted) {
      setState(() {});
      HimoToast.show(context, 'Wallet updated'.tr('ပိုက်ဆံအိတ် အချက်အလက် အသစ်ရရှိပါပြီ'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = _repo.getUser();
    final wallet = _repo.getWallet();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: isDark ? AppColors.surfaceCardDark : Colors.white,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar: User Avatar, Name, Language badge, Notifications
                _buildHeader(user, isDark),
                const SizedBox(height: AppSpacing.lg),

                // Wallet Balance Card
                _buildWalletCard(wallet, user, isDark),
                const SizedBox(height: AppSpacing.md),

                // Quick Send / Send Again row
                _buildQuickSendRow(isDark),
                const SizedBox(height: AppSpacing.md),

                // Active Passes / Tickets Banner
                _buildTicketsBanner(isDark),
                const SizedBox(height: AppSpacing.lg),

                // Services Grid (Top up, Bills, Deals, etc.)
                _buildServicesGrid(isDark),
                const SizedBox(height: AppSpacing.lg),

                // Promo Banner
                _buildPromoBanner(isDark),
                const SizedBox(height: AppSpacing.lg),

                // Recent Transactions with Filter Chips
                _buildRecentTransactions(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, bool isDark) {
    return Row(
      children: [
        // Avatar - Tapping navigates to Personal Information Screen
        InkWell(
          onTap: () {
            AppPreferences.triggerHaptic(HapticType.selection);
            Navigator.of(context).pushNamed('/personal-information');
          },
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/avatar_profile.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.gray900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LVL 2',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                user.maskedPhone,
                style: const TextStyle(fontSize: 12, color: AppColors.gray500),
              ),
            ],
          ),
        ),

        // Language toggle badge
        InkWell(
          onTap: _toggleLanguage,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, size: 14, color: AppColors.primaryDark),
                const SizedBox(width: 4),
                Text(
                  LocaleManager.languageBadge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.gray900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Notification Bell with unread badge
        InkWell(
          onTap: () => Navigator.of(context).pushNamed('/notifications'),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: isDark ? Colors.white : AppColors.gray900,
                ),
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(dynamic wallet, dynamic user, bool isDark) {
    return HimoDebitWalletCard(
      wallet: wallet,
      user: user,
      isDark: isDark,
      onToggleBalance: _toggleBalance,
      onTransfer: () => Navigator.of(context).pushNamed('/transfer-recipient').then((_) {
        if (mounted) setState(() {});
      }),
      onCashIn: () => Navigator.of(context).pushNamed('/cashin-methods').then((_) {
        if (mounted) setState(() {});
      }),
      onCashOut: () => Navigator.of(context).pushNamed('/cashout-methods').then((_) {
        if (mounted) setState(() {});
      }),
      onScanMe: () => Navigator.of(context).pushNamed('/my-qr'),
      onExploreMore: () => Navigator.of(context).pushNamed('/tier-benefits'),
    );
  }

  Widget _buildQuickSendRow(bool isDark) {
    final recentContacts = [
      {'name': 'Daw Thida', 'phone': '09 951 884 102', 'initials': 'DT', 'color': const Color(0xFF6366F1)},
      {'name': 'Ko Min Min', 'phone': '09 772 194 883', 'initials': 'KM', 'color': const Color(0xFF10B981)},
      {'name': 'Su Su', 'phone': '09 443 002 918', 'initials': 'SS', 'color': const Color(0xFFF59E0B)},
      {'name': 'Ma Thandar', 'phone': '09 250 811 405', 'initials': 'MT', 'color': const Color(0xFFEC4899)},
      {'name': 'U Aung Kyaw', 'phone': '09 970 412 399', 'initials': 'AK', 'color': const Color(0xFF3B82F6)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Send'.tr('အမြန်ငွေလွှဲ'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.gray900,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/transfer-recipient'),
              child: Text(
                'View All'.tr('အားလုံးကြည့်ရန်'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recentContacts.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              if (index == 0) {
                // New Recipient Shortcut
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).pushNamed('/transfer-recipient');
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: const Icon(Icons.add_rounded, size: 26, color: AppColors.primaryGold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'New'.tr('အသစ်'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.gray400 : AppColors.gray700,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final contact = recentContacts[index - 1];
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pushNamed(
                    '/transfer-amount',
                    arguments: {
                      'recipient': {
                        'name': contact['name'],
                        'phone': contact['phone'],
                        'isVerified': true,
                      },
                    },
                  ).then((_) {
                    if (mounted) setState(() {});
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (contact['color'] as Color).withValues(alpha: 0.18),
                        border: Border.all(
                          color: (contact['color'] as Color).withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          contact['initials'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: contact['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 60,
                      child: Text(
                        contact['name'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.gray300 : AppColors.gray800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildTicketsBanner(bool isDark) {
    return HimoCard(
      onTap: () => Navigator.of(context).pushNamed('/my-tickets'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: isDark ? AppColors.surfaceCardDark : Colors.white,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Passes & Tickets'.tr('လက်ရှိ လက်မှတ်နှင့် ပွဲဝင်ခွင့်များ'),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '2 Active digital entry passes available'.tr('အသုံးပြုနိုင်သော ဒစ်ဂျစ်တယ် လက်မှတ် ၂ စောင် ရှိပါသည်'),
                  style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gray400),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(bool isDark) {
    final services = MockData.mainServices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.services,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (context, index) {
            final s = services[index];
            final title = () {
              switch (s.id) {
                case 'topup': return AppStrings.topUp;
                case 'bills': return AppStrings.bills;
                case 'giftcards': return AppStrings.giftCards;
                case 'deals': return AppStrings.groupDeals;
                case 'events': return AppStrings.events;
                case 'movies': return AppStrings.cinema;
                case 'insurance': return AppStrings.insurance;
                case 'more': return AppStrings.more;
                default: return s.title;
              }
            }();
            return InkWell(
              onTap: () => Navigator.of(context).pushNamed(s.routeName),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceCardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.06) : AppColors.gray200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(s.icon, color: s.color ?? AppColors.primary, size: 24),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.gray900,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/campaign-detail'),
      borderRadius: AppRadius.cardBorder,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardBorder,
          image: const DecorationImage(
            image: AssetImage('assets/images/campaign_photo_cafe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardBorder,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.85),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '10% Instant Cashback'.tr('၁၀% ချက်ချင်း ငွေပြန်အမ်း'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pay with Himo QR at over 500 partner cafés.'.tr('မိတ်ဖက်ကော်ဖီဆိုင် ၅၀၀ ကျော်တွင် Himo QR ဖြင့် ပေးချေပါ'),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs: History / What's Up
        Row(
          children: [
            _buildTabItem(
              title: 'History'.tr('မှတ်တမ်း'),
              isSelected: _selectedMainTab == 'history',
              onTap: () {
                setState(() {
                  _selectedMainTab = 'history';
                });
              },
              isDark: isDark,
            ),
            const SizedBox(width: 24),
            _buildTabItem(
              title: "What's Up".tr('သတင်းနှင့် ပရိုမိုးရှင်း'),
              isSelected: _selectedMainTab == 'whats_up',
              onTap: () {
                setState(() {
                  _selectedMainTab = 'whats_up';
                });
              },
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Main Card (switches between History and What's Up)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedMainTab == 'history'
              ? _buildHistoryCard(isDark)
              : _buildWhatsUpCard(isDark),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF1A1C1E))
                      : (isDark ? AppColors.gray400 : const Color(0xFF727A87)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 3.5,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryDark : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(bool isDark) {
    final list = _repo.getTransactions().take(5).toList();

    return Container(
      key: const ValueKey('history_card'),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFEFEFEF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header: Recent History & See all button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent History'.tr('မကြာသေးမီက မှတ်တမ်း'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/history-all'),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5.5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF262A35) : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'See all'.tr('အားလုံးကြည့်ရန်'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Transaction Rows
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 36,
                      color: isDark ? AppColors.gray600 : AppColors.gray400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No recent transactions'.tr('မကြာသေးမီက မှတ်တမ်း မရှိသေးပါ'),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(list.length, (index) {
            final tx = list[index];
            final isIncome = tx.isIncome;
            final isLast = index == list.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () => _showTransactionDetail(context, tx, isDark),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Himo Brand gold/sand circle icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryGold,
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                          child: Center(
                            child: _getTxIconWidget(tx),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Title and Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF1A1C1E),
                                  height: 1.25,
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tx.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: isDark ? AppColors.gray400 : const Color(0xFF757E8C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Amount (-32,000 MMK or +32,000 MMK)
                        Text(
                          '${isIncome ? "+" : "-"}${CurrencyFormatter.formatMMK(tx.amount)}',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isIncome
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 74,
                    endIndent: 16,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF2F3F5),
                  ),
              ],
            );
          }),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildWhatsUpCard(bool isDark) {
    final updates = [
      {
        'title': '5% Cashback on Wallet to Bank',
        'desc': 'Transfer to KBZ Bank and receive instant 5% cashback this week.',
        'date': 'Valid till 30 Sep 2026',
        'tag': 'HOT PROMO',
        'icon': Icons.local_offer_rounded,
      },
      {
        'title': 'Zero Transfer Fees Campaign',
        'desc': 'Free transfers for all transactions above 30,000 MMK.',
        'date': 'Active Now',
        'tag': 'CAMPAIGN',
        'icon': Icons.flash_on_rounded,
      },
      {
        'title': 'Double Himo Points Weekend',
        'desc': 'Earn 2x Points for mobile top-ups and gift card purchases.',
        'date': 'Every Weekend',
        'tag': 'POINTS',
        'icon': Icons.stars_rounded,
      },
    ];

    return Container(
      key: const ValueKey('whatsup_card'),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFEFEFEF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "What's Up & Promotions".tr('သတင်းနှင့် ပရိုမိုးရှင်းများ'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '3 Updates'.tr('သတင်း ၃ ခု'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Update Rows
          ...List.generate(updates.length, (index) {
            final item = updates[index];
            final isLast = index == updates.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    HimoToast.show(context, '${item['title']} is active!');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryGold,
                                AppColors.primaryDark,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              item['icon'] as IconData,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : const Color(0xFF1A1C1E),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySubtle,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['tag'] as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['desc'] as String,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: isDark ? AppColors.gray400 : const Color(0xFF5A6270),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['date'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 74,
                    endIndent: 16,
                    color: isDark ? AppColors.borderDark : const Color(0xFFF2F3F5),
                  ),
              ],
            );
          }),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _getTxIconWidget(TransactionModel tx) {
    final titleLower = tx.title.toLowerCase();
    final isIncome = tx.isIncome;

    if (isIncome || titleLower.contains('receive')) {
      return const Icon(
        Icons.swap_horiz_rounded,
        color: Colors.white,
        size: 24,
      );
    } else {
      return _buildCardOutIcon();
    }
  }

  Widget _buildCardOutIcon() {
    return SizedBox(
      width: 26,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Credit card border
          Positioned(
            left: 1.5,
            top: 4,
            child: Container(
              width: 19,
              height: 13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                border: Border.all(color: Colors.white, width: 1.6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Container(
                    height: 1.4,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 1.5),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Container(
                      width: 4,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Small arrow pointing right at bottom-right
          Positioned(
            right: 0,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.all(0.5),
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, TransactionModel tx, bool isDark) {
    final isIncome = tx.isIncome;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E212B) : Colors.white,
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
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryGold,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Center(child: _getTxIconWidget(tx)),
              ),
              const SizedBox(height: 14),
              Text(
                tx.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${isIncome ? "+" : "-"}${CurrencyFormatter.formatMMK(tx.amount)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isIncome ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262A36) : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  children: [
                    _buildReceiptDetailRow('Transaction ID'.tr('လုပ်ငန်းစဉ် အမှတ်'), tx.id, isDark),
                    const Divider(height: 16),
                    _buildReceiptDetailRow('Status'.tr('အခြေအနေ'), 'Completed'.tr('အောင်မြင်သည်'), isDark, isStatus: true),
                    const Divider(height: 16),
                    _buildReceiptDetailRow('Date & Time'.tr('ရက်စွဲနှင့် အချိန်'), tx.date, isDark),
                    const Divider(height: 16),
                    _buildReceiptDetailRow('Fee'.tr('ဝန်ဆောင်ခ'), '0 MMK', isDark),
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
                        HimoToast.show(context, 'Receipt downloaded successfully'.tr('ပြေစာ သိမ်းဆည်းပြီးပါပြီ'));
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(
                          color: isDark ? AppColors.borderDark : const Color(0xFFD1D5DB),
                        ),
                      ),
                      child: Text(
                        'Share Receipt'.tr('ပြေစာ မျှဝေမည်'),
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                          fontWeight: FontWeight.w600,
                        ),
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
                      child: Text('Done'.tr('ပြီးပါပြီ'), style: const TextStyle(fontWeight: FontWeight.w700)),
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

  Widget _buildReceiptDetailRow(String label, String value, bool isDark, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.gray400 : const Color(0xFF6B7280),
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 14),
                SizedBox(width: 4),
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
      ],
    );
  }
}


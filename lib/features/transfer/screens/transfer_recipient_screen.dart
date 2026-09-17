import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class TransferRecipientScreen extends StatefulWidget {
  const TransferRecipientScreen({super.key});

  @override
  State<TransferRecipientScreen> createState() => _TransferRecipientScreenState();
}

class _TransferRecipientScreenState extends State<TransferRecipientScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _phoneOrSearchController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  int _selectedBankIndex = 0;
  final List<Map<String, dynamic>> _banks = [
    {'name': 'KBZ Bank', 'code': 'KBZ', 'color': Color(0xFF003882), 'prefix': '0019'},
    {'name': 'AYA Bank', 'code': 'AYA', 'color': Color(0xFFED1C24), 'prefix': '2001'},
    {'name': 'CB Bank', 'code': 'CB', 'color': Color(0xFFF37021), 'prefix': '0012'},
    {'name': 'Yoma Bank', 'code': 'YOMA', 'color': Color(0xFF9E1B32), 'prefix': '0088'},
    {'name': 'uab bank', 'code': 'UAB', 'color': Color(0xFF0B5394), 'prefix': '5001'},
  ];

  final List<Map<String, String>> _allRecipients = [
    {'name': 'Daw Thida', 'phone': '09 951 884 102', 'initials': 'DT', 'tier': 'Level 2 Verified'},
    {'name': 'U Kyaw Swar', 'phone': '09 772 104 991', 'initials': 'KS', 'tier': 'Level 2 Verified'},
    {'name': 'Ko Aung Zaw', 'phone': '09 448 201 883', 'initials': 'AZ', 'tier': 'Level 1 Verified'},
    {'name': 'Ma Ei Thinzar', 'phone': '09 250 918 440', 'initials': 'ET', 'tier': 'Level 2 Verified'},
    {'name': 'Ko Min Khant', 'phone': '09 420 119 552', 'initials': 'MK', 'tier': 'Level 2 Verified'},
    {'name': 'Daw Sandar Win', 'phone': '09 798 221 445', 'initials': 'SW', 'tier': 'Level 2 Verified'},
  ];

  String _searchQuery = '';
  bool _isLookingUp = false;
  String? _resolvedCustomName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _phoneOrSearchController.addListener(_onPhoneChanged);
    _bankAccountController.addListener(_onBankAccChanged);
  }

  void _onPhoneChanged() {
    final query = _phoneOrSearchController.text.trim();
    setState(() {
      _searchQuery = query;
    });

    final digits = query.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 9) {
      _simulateLookup(digits);
    } else {
      if (_resolvedCustomName != null) {
        setState(() => _resolvedCustomName = null);
      }
    }
  }

  void _simulateLookup(String digits) {
    if (_isLookingUp) return;
    setState(() => _isLookingUp = true);

    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      // Match with known contacts or generate a verified fintech recipient
      final match = _allRecipients.firstWhere(
        (r) => r['phone']!.replaceAll(RegExp(r'\D'), '') == digits,
        orElse: () => {'name': 'Verified Himo User (${digits.substring(digits.length - 4)})', 'phone': queryFormatted(digits), 'initials': 'VU'},
      );
      setState(() {
        _isLookingUp = false;
        _resolvedCustomName = match['name'];
      });
    });
  }

  void _onBankAccChanged() {
    final acc = _bankAccountController.text.trim();
    if (acc.length >= 8 && _accountNameController.text.isEmpty) {
      final bank = _banks[_selectedBankIndex]['name'] as String;
      setState(() {
        _accountNameController.text = 'U KO KO LWIN ($bank Verified)';
      });
    }
  }

  String queryFormatted(String raw) {
    if (raw.startsWith('09') && raw.length >= 9) {
      return '${raw.substring(0, 2)} ${raw.substring(2, 5)} ${raw.substring(5)}';
    }
    return raw;
  }

  void _proceedWithWalletRecipient(String name, String phone) {
    Navigator.of(context).pushNamed(
      '/transfer-amount',
      arguments: {
        'name': name,
        'phone': phone,
        'type': 'wallet',
        'badge': 'Himo Pay Wallet',
        'verified': 'true',
      },
    );
  }

  void _proceedWithBankRecipient() {
    final bank = _banks[_selectedBankIndex]['name'] as String;
    final acc = _bankAccountController.text.trim();
    final holder = _accountNameController.text.trim();

    if (acc.isEmpty || acc.length < 6) {
      HimoToast.show(context, 'Please enter a valid bank account number'.tr('ကျေးဇူးပြု၍ မှန်ကန်သော ဘဏ်အကောင့်နံပါတ် ရိုက်ထည့်ပါ'), isError: true);
      return;
    }

    final recipientName = holder.isEmpty ? 'Account Holder ($bank)' : holder;

    Navigator.of(context).pushNamed(
      '/transfer-amount',
      arguments: {
        'name': recipientName,
        'phone': '$bank •••• ${acc.length > 4 ? acc.substring(acc.length - 4) : acc}',
        'type': 'bank',
        'bank': bank,
        'accountNumber': acc,
        'badge': '$bank Direct',
        'verified': 'true',
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneOrSearchController.dispose();
    _bankAccountController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _allRecipients.where((r) {
      final q = _searchQuery.toLowerCase();
      final matchName = r['name']!.toLowerCase().contains(q);
      final matchPhone = r['phone']!.replaceAll(' ', '').contains(q.replaceAll(' ', ''));
      return matchName || matchPhone;
    }).toList();

    return Scaffold(
      appBar: HimoAppBar(title: 'Transfer Money'.tr('ငွေလွှဲမည်')),
      body: SafeArea(
        child: Column(
          children: [
            // Top TabBar for Wallet vs Bank Transfer
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceCardDark : AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? AppColors.gray400 : AppColors.gray600,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: 'To Himo Wallet'.tr('Himo ပိုက်ဆံအိတ်သို့')),
                  Tab(text: 'To Bank Account'.tr('ဘဏ်အကောင့်သို့')),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: To Himo Wallet
                  _buildWalletTransferTab(isDark, filtered),
                  // Tab 2: To Bank Account
                  _buildBankTransferTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletTransferTab(bool isDark, List<Map<String, String>> filtered) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search / Phone Number Input Box
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : Colors.white,
              borderRadius: AppRadius.cardBorder,
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneOrSearchController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number or name (09...)'.tr('ဖုန်းနံပါတ် သို့မဟုတ် အမည် ရိုက်ထည့်ပါ'),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.gray400),
                    ),
                  ),
                ),
                if (_phoneOrSearchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () => _phoneOrSearchController.clear(),
                    child: const Icon(Icons.clear, size: 18, color: AppColors.gray400),
                  ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primary),
                  tooltip: 'Scan QR Code'.tr('QR ဖတ်မည်'),
                  onPressed: () => Navigator.of(context).pushNamed('/scan-qr'),
                ),
              ],
            ),
          ),

          // Instant Lookup Badge if user typed phone
          if (_isLookingUp)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Text('Verifying recipient...'.tr('လက်ခံသူ စစ်ဆေးနေပါသည်...'), style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                ],
              ),
            )
          else if (_resolvedCustomName != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => _proceedWithWalletRecipient(_resolvedCustomName!, _phoneOrSearchController.text),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_rounded, color: AppColors.success, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_resolvedCustomName!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primaryDark)),
                            Text(_phoneOrSearchController.text, style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
                          ],
                        ),
                      ),
                      const Text('Transfer >', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent & Contacts'.tr('မကြာသေးမီက လွှဲခဲ့သူများ'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text('${filtered.length} ${'contacts'.tr('ဦး')}', style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
            ],
          ),
          const SizedBox(height: 10),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No contacts found'.tr('အဆက်အသွယ် မတွေ့ပါ'), style: const TextStyle(color: AppColors.gray400)),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      return HimoCard(
                        onTap: () => _proceedWithWalletRecipient(r['name']!, r['phone']!),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.primary.withOpacity(0.18),
                              child: Text(
                                r['initials']!,
                                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(r['name']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified, size: 14, color: AppColors.primary),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(r['phone']!, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.gray400),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          HimoButton(
            text: 'Continue'.tr('ရှေ့သို့'),
            onPressed: () {
              final name = _resolvedCustomName ?? (_phoneOrSearchController.text.isEmpty ? 'Daw Thida' : _phoneOrSearchController.text);
              final phone = _phoneOrSearchController.text.isEmpty ? '09 951 884 102' : _phoneOrSearchController.text;
              _proceedWithWalletRecipient(name, phone);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildBankTransferTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Recipient Bank'.tr('လက်ခံမည့် ဘဏ် ရွေးချယ်ပါ'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          // Bank horizontal choices
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _banks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final b = _banks[index];
                final isSelected = _selectedBankIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedBankIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : (isDark ? AppColors.surfaceCardDark : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.gray200),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: b['color'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            b['code'] as String,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b['name'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.primary : (isDark ? Colors.white : AppColors.gray900),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Bank Account Number'.tr('ဘဏ်အကောင့် နံပါတ်'), style: TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _bankAccountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 0019 2039 1849 0182',
              hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
              prefixIcon: const Icon(Icons.account_balance, color: AppColors.primary, size: 20),
              fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Text('Account Holder Name (Optional lookup)'.tr('အကောင့်ပိုင်ရှင် အမည်'), style: TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _accountNameController,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.gray900,
            ),
            decoration: InputDecoration(
              hintText: 'Enter or auto-verify recipient name'.tr('အကောင့်ပိုင်ရှင် အမည် ရိုက်ထည့်ပါ'),
              hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
              fillColor: isDark ? AppColors.surfaceCardDark : Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.cardBorder,
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Direct interbank transfer powered by CBM-NET & CBM Pay. Instant settlement.'.tr('CBM-NET စနစ်ဖြင့် တိုက်ရိုက် ငွေလွှဲပြောင်းပေးပါမည်။ ချက်ချင်းရောက်ရှိပါသည်။'),
                    style: const TextStyle(fontSize: 11, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          HimoButton(
            text: 'Review Bank Transfer'.tr('ဘဏ်ငွေလွှဲ အချက်အလက် စစ်ဆေးမည်'),
            onPressed: _proceedWithBankRecipient,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}


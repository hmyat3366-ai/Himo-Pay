import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/localization/app_strings.dart';
import '../../../data/repositories/himo_repository.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  int _selectedTab = 1; // 0: Scan, 1: Receive, 2: Pay
  int? _specifiedAmount;
  int _refreshCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _refreshCountdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (_refreshCountdown > 1) {
            _refreshCountdown--;
          } else {
            _refreshCountdown = 60;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _promptSpecifyAmount() {
    final controller = TextEditingController(
      text: _specifiedAmount != null ? CurrencyFormatter.formatNumberOnly(_specifiedAmount!) : '',
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.specifyAmount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    prefixText: 'Ks ',
                    hintText: AppStrings.enterAmount,
                    prefixStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_specifiedAmount != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _specifiedAmount = null);
                            Navigator.pop(ctx);
                          },
                          child: Text('Clear'.tr('ဖျက်မည်')),
                        ),
                      ),
                    if (_specifiedAmount != null) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: HimoButton(
                        text: 'Save Amount'.tr('ပမာဏ သတ်မှတ်မည်'),
                        onPressed: () {
                          final parsed = CurrencyFormatter.parseAmount(controller.text);
                          if (parsed > 0) {
                            setState(() => _specifiedAmount = parsed);
                            Navigator.pop(ctx);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = HimoRepository().currentUser;
    final balance = HimoRepository().balance;

    return Scaffold(
      appBar: HimoAppBar(
        title: AppStrings.myQrCode,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
            onPressed: () => Navigator.of(context).pushNamed('/scan-qr'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 3 Segmented Pills: Scan | QR to Receive | QR to Pay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevatedDark : AppColors.gray200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildSegmentTab(AppStrings.navScan, 0, isDark),
                    _buildSegmentTab('QR to Receive'.tr('ငွေလက်ခံ QR'), 1, isDark),
                    _buildSegmentTab('QR to Pay'.tr('ငွေပေးချေ QR'), 2, isDark),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _selectedTab == 1
                  ? _buildReceiveView(isDark, user)
                  : _buildPayView(isDark, user, balance),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentTab(String title, int index, bool isDark) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            Navigator.of(context).pushNamed('/scan-qr');
          } else {
            setState(() => _selectedTab = index);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.surfaceDark : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiveView(bool isDark, dynamic user) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      children: [
        HimoCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Text(
                user.name.toUpperCase(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2),
              ),
              const SizedBox(height: 4),
              Text(
                user.phone,
                style: const TextStyle(fontSize: 13, color: AppColors.gray500),
              ),
              const SizedBox(height: 18),
              // QR with avatar
              Container(
                width: 220,
                height: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/illustration_qr_payment.jpg',
                      fit: BoxFit.contain,
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar_profile.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_specifiedAmount != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Amount: ${CurrencyFormatter.formatMMK(_specifiedAmount!)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => _specifiedAmount = null),
                        child: const Icon(Icons.close, size: 16, color: AppColors.gray500),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _promptSpecifyAmount,
          icon: const Icon(Icons.edit_note_rounded, size: 20),
          label: Text(_specifiedAmount == null ? AppStrings.specifyAmount : 'Change Specified Amount'.tr('ပမာဏ ပြောင်းလဲမည်')),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            HimoToast.show(context, 'QR Code image saved to Gallery'.tr('QR ကုဒ်ကို ဓာတ်ပုံထဲသို့ သိမ်းဆည်းပြီးပါပြီ'));
          },
          icon: const Icon(Icons.share_rounded, size: 18),
          label: Text('Save & Share QR Code'.tr('QR ကုဒ် သိမ်းဆည်း/မျှဝေမည်')),
        ),
      ],
    );
  }

  Widget _buildPayView(bool isDark, dynamic user, int balance) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      children: [
        HimoCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              Text(
                'Show to Cashier / Merchant'.tr('ငွေရှင်းကောင်တာ သို့မဟုတ် အရောင်းဆိုင်သို့ ပြသပါ'),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray500),
              ),
              const SizedBox(height: 16),
              // Barcode
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        35,
                        (i) => Container(
                          width: (i % 3 == 0) ? 4 : 2,
                          height: 42,
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('9840 2190 4482 1092', style: TextStyle(color: Colors.black, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Dynamic QR
              Container(
                width: 170,
                height: 170,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('assets/images/illustration_qr_payment.jpg'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${'Auto-refreshes in'.tr('အလိုအလျောက် အသစ်လဲရန်ကျန်')} $_refreshCountdown s',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        HimoCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Paying from Himo Wallet'.tr('Himo ပိုက်ဆံအိတ်မှ ငွေပေးချေမည်'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('${'Balance'.tr('လက်ကျန်ငွေ')}: ${CurrencyFormatter.formatMMK(balance)}', style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

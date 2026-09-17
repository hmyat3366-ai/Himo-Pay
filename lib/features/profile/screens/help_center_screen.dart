import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How do I upgrade to KYC Tier 2 status?',
      'a': 'Go to Profile > User Level and submit your Myanmar National Registration Card (NRC front & back) along with a live selfie verification. Approval takes under 5 minutes.',
    },
    {
      'q': 'What are the fees for wallet-to-wallet transfer?',
      'a': 'Wallet transfers between any Himo Pay users are 100% free with 0% processing fees. There are no charges regardless of amount or time of day.',
    },
    {
      'q': 'How do I cash out funds to my commercial bank?',
      'a': 'Tap Cash Out on Home or Wallet, choose Bank Transfer (KBZ, CB, AYA, or Yoma), enter your account details and amount. Bank transfers incur a 0.2% processing fee and settle within 2 minutes.',
    },
    {
      'q': 'How do I use promo vouchers and group deals?',
      'a': 'After unlocking or joining a deal, your digital vouchers are stored under Wallet > My Vouchers / Deals. Present the barcode or voucher code to the cashier at checkout.',
    },
    {
      'q': 'What should I do if I forgot my 6-digit passcode?',
      'a': 'On the passcode login screen, tap "Forgot Passcode". You will receive an SMS OTP to verify your identity and securely reset your 6-digit PIN.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = _searchController.text.trim().toLowerCase();

    final filtered = _faqs.where((f) {
      if (query.isEmpty) return true;
      return f['q']!.toLowerCase().contains(query) || f['a']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: HimoAppBar(title: 'Help Center & FAQs'.tr('အကူအညီနှင့် မေးလေ့ရှိသော မေးခွန်းများ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Search help articles & questions...',
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.gray500),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('FREQUENTLY ASKED QUESTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            ...filtered.map((faq) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HimoCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    title: Text(faq['q']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(faq['a']!, style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.gray500)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            HimoCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Still have questions?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Our priority customer support team is available 24/7.', style: TextStyle(fontSize: 12, color: AppColors.gray500), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  HimoButton(
                    text: 'Chat with Live Agent',
                    onPressed: () => Navigator.of(context).pushNamed('/live-support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

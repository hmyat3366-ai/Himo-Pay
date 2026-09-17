import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/supabase/supabase_config.dart';
import '../../../data/repositories/himo_repository.dart';

class LinkedCardsScreen extends StatefulWidget {
  const LinkedCardsScreen({super.key});

  @override
  State<LinkedCardsScreen> createState() => _LinkedCardsScreenState();
}

class _LinkedCardsScreenState extends State<LinkedCardsScreen> {
  List<Map<String, String>> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    final uid = HimoRepository().activeUserId;
    final userName = HimoRepository().currentUser.name;
    try {
      final rows = await SupabaseConfig.client
          .from('digital_cards')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      if (rows is List && rows.isNotEmpty) {
        final parsed = rows.map<Map<String, String>>((r) {
          final cardNum = r['card_number']?.toString() ?? '4242';
          final digits = cardNum.replaceAll(RegExp(r'\D'), '');
          final last4 = digits.length >= 4 ? digits.substring(digits.length - 4) : '4242';
          final rawType = r['card_type']?.toString().toUpperCase() ?? 'VISA';
          final isMaster = rawType.contains('MASTER');
          return {
            'type': isMaster ? 'MASTERCARD' : 'VISA',
            'last4': last4,
            'holder': r['card_holder']?.toString() ?? userName,
            'expiry': r['expiry_date']?.toString() ?? '12/29',
            'color1': isMaster ? '0xFFFF5E14' : '0xFF1A1A1A',
            'color2': isMaster ? '0xFFCC4204' : '0xFF0A0A0A',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _cards = parsed;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching digital cards: $e');
    }

    if (mounted) {
      setState(() {
        _cards = [
          {
            'type': 'VISA',
            'last4': '8891',
            'holder': userName,
            'expiry': '12/29',
            'color1': '0xFF1A1A1A',
            'color2': '0xFF0A0A0A',
          },
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewCard() async {
    final uid = HimoRepository().activeUserId;
    final holder = HimoRepository().currentUser.name;
    final cardId = 'card-${DateTime.now().millisecondsSinceEpoch}';
    try {
      await SupabaseConfig.client.from('digital_cards').insert({
        'id': cardId,
        'user_id': uid,
        'card_number': '4242 •••• •••• 9941',
        'card_holder': holder,
        'expiry_date': '05/30',
        'card_type': 'VISA Platinum',
        'is_frozen': false,
        'daily_spending_limit': 1500000,
      });
    } catch (e) {
      debugPrint('Save card error: $e');
    }

    if (mounted) {
      HimoToast.show(context, 'New Card added successfully'.tr('ကတ်အသစ် ထည့်သွင်းပြီးပါပြီ'));
      await _fetchCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HimoAppBar(title: 'Linked Cards'.tr('ချိတ်ဆက်ထားသော ကတ်များ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: _cards.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                    final card = _cards[index];
                    final isGold = card['type'] == 'MASTERCARD';

                    return Container(
                      height: 170,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(int.parse(card['color1']!)),
                            Color(int.parse(card['color2']!)),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                card['type']!,
                                style: TextStyle(
                                  color: isGold ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                              Icon(
                                Icons.contactless,
                                color: isGold ? Colors.black : Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                          Text(
                            '•••• •••• •••• ${card["last4"]}',
                            style: TextStyle(
                              color: isGold ? Colors.black : Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CARD HOLDER',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: (isGold ? Colors.black : Colors.white).withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    card['holder']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isGold ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'EXPIRES',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: (isGold ? Colors.black : Colors.white).withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    card['expiry']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isGold ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              HimoButton(
                text: 'Add New Card',
                icon: const Icon(Icons.add, color: AppColors.black, size: 20),
                onPressed: _addNewCard,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

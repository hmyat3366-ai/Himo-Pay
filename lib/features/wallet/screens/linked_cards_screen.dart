import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class LinkedCardsScreen extends StatefulWidget {
  const LinkedCardsScreen({super.key});

  @override
  State<LinkedCardsScreen> createState() => _LinkedCardsScreenState();
}

class _LinkedCardsScreenState extends State<LinkedCardsScreen> {
  final List<Map<String, String>> _cards = [
    {
      'type': 'VISA',
      'last4': '4242',
      'holder': 'HTET MYAT OO',
      'expiry': '12/28',
      'color1': '0xFF1A1A1A',
      'color2': '0xFF0A0A0A',
    },
    {
      'type': 'MASTERCARD',
      'last4': '8891',
      'holder': 'HTET MYAT OO',
      'expiry': '08/29',
      'color1': '0xFFFF5E14',
      'color2': '0xFFCC4204',
    },
  ];

  void _addNewCard() {
    HimoToast.show(context, 'New Card added successfully'.tr('ကတ်အသစ် ထည့်သွင်းပြီးပါပြီ'));
    setState(() {
      _cards.add({
        'type': 'VISA',
        'last4': '9941',
        'holder': 'HTET MYAT OO',
        'expiry': '05/30',
        'color1': '0xFF2C2C2E',
        'color2': '0xFF1C1C1E',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HimoAppBar(title: 'Linked Cards'.tr('ချိတ်ဆက်ထားသော ကတ်များ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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

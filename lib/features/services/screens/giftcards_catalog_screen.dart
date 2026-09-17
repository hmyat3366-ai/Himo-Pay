import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';

class GiftcardsCatalogScreen extends StatefulWidget {
  const GiftcardsCatalogScreen({super.key});

  @override
  State<GiftcardsCatalogScreen> createState() => _GiftcardsCatalogScreenState();
}

class _GiftcardsCatalogScreenState extends State<GiftcardsCatalogScreen> {
  final HimoRepository _repo = HimoRepository();

  final List<Map<String, dynamic>> _cards = [
    {
      'title': 'Steam Wallet',
      'brand': 'STEAM',
      'color': const Color(0xFF171A21),
      'textColor': Colors.white,
      'priceMMK': 35000,
      'tier': '\$10 USD Global Code',
    },
    {
      'title': 'Apple App Store',
      'brand': 'APPLE',
      'color': const Color(0xFF333333),
      'textColor': Colors.white,
      'priceMMK': 35000,
      'tier': '\$10 USD US Region',
    },
    {
      'title': 'Google Play',
      'brand': 'PLAY',
      'color': const Color(0xFF01875F),
      'textColor': Colors.white,
      'priceMMK': 35000,
      'tier': '\$10 USD Balance',
    },
    {
      'title': 'Netflix Premium',
      'brand': 'NETFLIX',
      'color': const Color(0xFFE50914),
      'textColor': Colors.white,
      'priceMMK': 18000,
      'tier': '1 Month 4K UHD Pass',
    },
    {
      'title': 'Spotify Premium',
      'brand': 'SPOTIFY',
      'color': const Color(0xFF1DB954),
      'textColor': Colors.black,
      'priceMMK': 9000,
      'tier': '1 Month Individual',
    },
    {
      'title': 'PlayStation Store',
      'brand': 'PSN',
      'color': const Color(0xFF003791),
      'textColor': Colors.white,
      'priceMMK': 35000,
      'tier': '\$10 USD Voucher',
    },
  ];

  void _buyGiftCard(Map<String, dynamic> card) {
    final price = card['priceMMK'] as int;
    if (_repo.balance < price) {
      HimoToast.show(context, 'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    _repo.deductBalance(price);
    _repo.addPoints((price / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-GC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '${card['title']} Purchase',
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: price,
        type: TransactionType.outMoney,
        category: 'Gift Card',
      ),
    );

    final code = '${card['brand']}-${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 9)}-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}';

    Navigator.of(context).pushNamed(
      '/giftcards-success',
      arguments: {
        'card': card,
        'code': code,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Gift Cards'.tr('ဂိမ်းနှင့် လက်ဆောင်ကတ်များ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            Text(
              'Digital Vouchers & Gift Cards'.tr('ဒစ်ဂျစ်တယ် ကူပွန်များနှင့် လက်ဆောင်ကတ်များ'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Instant digital redeem codes delivered directly to your wallet'.tr('ဝယ်ယူပြီးသည်နှင့် ဒစ်ဂျစ်တယ် ကုဒ်များကို ပိုက်ဆံအိတ်သို့ ချက်ချင်း ပေးပို့ပါသည်'),
              style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, i) {
                final card = _cards[i];
                return HimoCard(
                  onTap: () => _buyGiftCard(card),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: card['color'] as Color,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            card['brand'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: card['textColor'] as Color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card['tier'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: AppColors.gray500),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        CurrencyFormatter.formatMMK(card['priceMMK'] as int),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

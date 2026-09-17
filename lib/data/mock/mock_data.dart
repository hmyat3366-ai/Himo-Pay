import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../models/service_model.dart';
import '../models/voucher_model.dart';
import '../models/ticket_model.dart';
import '../../core/constants/app_colors.dart';

class MockData {
  static const UserModel currentUser = UserModel(
    name: 'HTET MYAT OO',
    phone: '09950786548',
    maskedPhone: '*******6548',
    tier: 'Subscriber Level 2',
    isApproved: true,
    referralCode: 'S3WMGB',
  );

  static WalletModel initialWallet = const WalletModel(
    balance: 125000,
    points: 661,
    isBalanceHidden: false,
  );

  static final List<TransactionModel> transactions = [
    const TransactionModel(
      id: 'HM-TX-99501',
      title: 'Move Money from Wallet to Bank',
      date: '1 September 2026, 7:39 AM',
      amount: 32000,
      type: TransactionType.outMoney,
      category: 'wallet_to_bank',
    ),
    const TransactionModel(
      id: 'HM-TX-99500',
      title: 'Receive Money from Wallet',
      date: '1 September 2026, 7:34 AM',
      amount: 32000,
      type: TransactionType.inMoney,
      category: 'receive_wallet',
    ),
    const TransactionModel(
      id: 'HM-TX-99480',
      title: 'Move Money from Wallet to Bank',
      date: '31 July 2026, 8:09 PM',
      amount: 32380,
      type: TransactionType.outMoney,
      category: 'wallet_to_bank',
    ),
    const TransactionModel(
      id: 'HM-TX-99479',
      title: 'Receive Money from Wallet',
      date: '31 July 2026, 8:09 PM',
      amount: 32000,
      type: TransactionType.inMoney,
      category: 'receive_wallet',
    ),
    const TransactionModel(
      id: 'HM-TX-99478',
      title: 'Move Money from Wallet to Bank',
      date: '31 July 2026, 8:07 PM',
      amount: 1000,
      type: TransactionType.outMoney,
      category: 'wallet_to_bank',
    ),
    const TransactionModel(
      id: 'HM-TX-99412',
      title: 'Rangoon Tea House',
      date: '25 Jul 2026, 10:45 AM',
      amount: 18500,
      type: TransactionType.outMoney,
      category: 'Dining',
    ),
    const TransactionModel(
      id: 'HM-TX-99401',
      title: 'Cash In from KBZ Bank',
      date: '24 Jul 2026, 04:20 PM',
      amount: 100000,
      type: TransactionType.inMoney,
      category: 'Top Up',
    ),
  ];

  static const List<ServiceItemModel> mainServices = [
    ServiceItemModel(id: 'topup', title: 'Top Up', icon: Icons.phone_android_rounded, routeName: '/topup-main', color: Colors.purple),
    ServiceItemModel(id: 'bills', title: 'Pay Bills', icon: Icons.receipt_long_rounded, routeName: '/bills-categories', color: Colors.amber),
    ServiceItemModel(id: 'giftcards', title: 'Gift Cards', icon: Icons.card_giftcard_rounded, routeName: '/giftcards-catalog', color: Colors.redAccent),
    ServiceItemModel(id: 'deals', title: 'Deals', icon: Icons.local_offer_outlined, routeName: '/deals-browse', color: Colors.teal),
    ServiceItemModel(id: 'events', title: 'Events', icon: Icons.confirmation_number_outlined, routeName: '/events-browse', color: Colors.indigo),
    ServiceItemModel(id: 'movies', title: 'Movies', icon: Icons.movie_outlined, routeName: '/movies-listing', color: Colors.pink),
    ServiceItemModel(id: 'insurance', title: 'Insurance', icon: Icons.shield_outlined, routeName: '/insurance-plans', color: Colors.blueGrey),
    ServiceItemModel(id: 'more', title: 'More', icon: Icons.grid_view_rounded, routeName: '/more-services', color: AppColors.primary),
  ];

  static const List<TicketModel> tickets = [
    TicketModel(
      id: 'TCK-2026-991',
      title: 'Yangon Tech Summit 2026',
      subtitle: 'VIP Delegate Pass',
      venue: 'Lotte Hotel Yangon, Grand Ballroom',
      date: '24 Oct 2026',
      time: '09:00 AM - 05:00 PM',
      seat: 'Hall A - Seat 42',
    ),
    TicketModel(
      id: 'TCK-2026-442',
      title: 'Dune: Part Two (IMAX)',
      subtitle: 'Cinema City Junction City',
      venue: 'Junction City, Hall 1',
      date: 'Tomorrow, 16 Sep',
      time: '07:30 PM',
      seat: 'Row G - Seat 14, 15',
    ),
  ];

  static const List<VoucherModel> vouchers = [
    VoucherModel(
      code: 'AR10',
      title: 'Asia Royal Hospital - 10% Discount',
      tag: 'ASIA ROYAL',
      validity: '01/01/2026 - 31/12/2026',
      places: 'Asia Royal Hospital, Yangon',
      description: 'Get 10% discount on consultation and laboratory services at Asia Royal Hospital with this voucher.',
      points: 200,
      isClaimed: true,
    ),
    VoucherModel(
      code: 'AT10',
      title: 'AYA PAY COFFEE (10% Discount)',
      tag: 'AYA COFFEE',
      validity: '01/09/2026 - 31/10/2026',
      places: 'Selected partner cafes across Yangon & Mandalay',
      description: 'Enjoy 10% off your favorite beverages at participating partner coffee shops when paying with Himo Pay.',
      points: 150,
      isClaimed: true,
    ),
    VoucherModel(
      code: 'AYAZ99',
      title: 'AYA Zay - 9.9 Mega Sale',
      tag: 'AYA ZAY',
      validity: '01/09/2026 - 15/09/2026',
      places: 'Online Shopping App',
      description: 'Exclusive 15,000 MMK cashback voucher on your minimum 50,000 MMK shopping cart.',
      points: 300,
      isClaimed: false,
    ),
  ];
}

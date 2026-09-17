import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../models/voucher_model.dart';
import '../models/ticket_model.dart';
import '../mock/mock_data.dart';

import '../../core/storage/app_preferences.dart';

class HimoRepository {
  static final HimoRepository _instance = HimoRepository._internal();
  factory HimoRepository() => _instance;
  HimoRepository._internal() {
    _initNotifiers();
  }

  final UserModel _user = MockData.currentUser;
  late WalletModel _wallet;
  final List<TransactionModel> _transactions = List.from(MockData.transactions);
  final List<VoucherModel> _vouchers = List.from(MockData.vouchers);
  final List<TicketModel> _tickets = List.from(MockData.tickets);

  late final ValueNotifier<WalletModel> walletNotifier;
  late final ValueNotifier<List<TransactionModel>> transactionsNotifier;

  void _initNotifiers() {
    _wallet = MockData.initialWallet.copyWith(
      isBalanceHidden: AppPreferences.balanceHiddenNotifier.value,
    );
    walletNotifier = ValueNotifier<WalletModel>(_wallet);
    transactionsNotifier = ValueNotifier<List<TransactionModel>>(List.unmodifiable(_transactions));
  }

  UserModel getUser() => _user;
  UserModel get currentUser => _user;

  WalletModel getWallet() {
    _wallet = _wallet.copyWith(isBalanceHidden: AppPreferences.balanceHiddenNotifier.value);
    return _wallet;
  }
  int get balance => _wallet.balance;
  int get points => _wallet.points;

  List<TransactionModel> getTransactions() => List.unmodifiable(_transactions);
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  List<VoucherModel> getVouchers() => List.unmodifiable(_vouchers);
  List<VoucherModel> get vouchers => List.unmodifiable(_vouchers);

  List<TicketModel> getTickets() => List.unmodifiable(_tickets);
  List<TicketModel> get tickets => List.unmodifiable(_tickets);

  void toggleBalanceVisibility() {
    AppPreferences.toggleBalanceHidden();
    _wallet = _wallet.copyWith(isBalanceHidden: AppPreferences.balanceHiddenNotifier.value);
    walletNotifier.value = _wallet;
  }

  bool deductBalance(int amount) {
    if (_wallet.balance < amount) return false;
    _wallet = _wallet.copyWith(balance: _wallet.balance - amount);
    walletNotifier.value = _wallet;
    return true;
  }

  void addBalance(int amount) {
    _wallet = _wallet.copyWith(balance: _wallet.balance + amount);
    walletNotifier.value = _wallet;
  }

  void claimDailyCheckinPoints(int pointsToAdd) {
    _wallet = _wallet.copyWith(points: _wallet.points + pointsToAdd);
    walletNotifier.value = _wallet;
  }

  void addPoints(int pointsToAdd) {
    _wallet = _wallet.copyWith(points: _wallet.points + pointsToAdd);
    walletNotifier.value = _wallet;
  }

  void deductPoints(int pts) {
    _wallet = _wallet.copyWith(points: (_wallet.points - pts).clamp(0, 999999999));
    walletNotifier.value = _wallet;
  }

  void addTransaction(TransactionModel tx) {
    _transactions.insert(0, tx);
    transactionsNotifier.value = List.unmodifiable(_transactions);
  }

  void addTicket(TicketModel ticket) {
    _tickets.insert(0, ticket);
  }

  void addVoucher(VoucherModel voucher) {
    _vouchers.insert(0, voucher);
  }

  String generateTxId(String prefix) {
    final now = DateTime.now();
    final random = (1000 + Random().nextInt(9000)).toString();
    final suffix = now.millisecondsSinceEpoch.toString().substring(7);
    return 'HM-$prefix-$suffix$random';
  }
}


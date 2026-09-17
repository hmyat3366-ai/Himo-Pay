import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../models/notification_model.dart';
import '../models/voucher_model.dart';
import '../models/ticket_model.dart';
import '../mock/mock_data.dart';
import '../../core/storage/app_preferences.dart';
import '../../core/supabase/supabase_config.dart';
import '../../core/services/auth_service.dart';

class HimoRepository {
  static final HimoRepository _instance = HimoRepository._internal();
  factory HimoRepository() => _instance;
  HimoRepository._internal() {
    _initNotifiers();
  }

  UserModel _user = MockData.currentUser;
  late WalletModel _wallet;
  final List<TransactionModel> _transactions = List.from(MockData.transactions);
  final List<NotificationModel> _notifications = [];
  final List<VoucherModel> _vouchers = List.from(MockData.vouchers);
  final List<TicketModel> _tickets = List.from(MockData.tickets);

  late final ValueNotifier<WalletModel> walletNotifier;
  late final ValueNotifier<List<TransactionModel>> transactionsNotifier;
  late final ValueNotifier<List<NotificationModel>> notificationsNotifier;

  String? _activeCustomUserId;

  /// Returns the current active user ID.
  /// Prefers custom/saved ID from AppPreferences, then auth session, then fallback demo.
  String get activeUserId {
    if (_activeCustomUserId != null && _activeCustomUserId!.isNotEmpty) {
      return _activeCustomUserId!;
    }
    final prefUserId = AppPreferences.activeUserId;
    if (prefUserId != null && prefUserId.isNotEmpty) {
      return prefUserId;
    }
    final authUser = AuthService.currentUser;
    if (authUser != null && authUser.id.isNotEmpty) {
      return authUser.id;
    }
    return 'user-min-khant';
  }

  void setActiveUserId(String id) {
    _activeCustomUserId = id;
    fetchFromSupabase();
  }

  void _initNotifiers() {
    final savedId = AppPreferences.activeUserId;
    if (savedId != null && savedId.isNotEmpty) {
      _activeCustomUserId = savedId;
    }

    _wallet = MockData.initialWallet.copyWith(
      isBalanceHidden: AppPreferences.balanceHiddenNotifier.value,
    );
    walletNotifier = ValueNotifier<WalletModel>(_wallet);
    transactionsNotifier =
        ValueNotifier<List<TransactionModel>>(List.unmodifiable(_transactions));
    notificationsNotifier =
        ValueNotifier<List<NotificationModel>>(List.unmodifiable(_notifications));

    // Kick off real data fetch asynchronously
    fetchFromSupabase();
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

  List<NotificationModel> getNotifications() => List.unmodifiable(_notifications);

  List<VoucherModel> getVouchers() => List.unmodifiable(_vouchers);
  List<VoucherModel> get vouchers => List.unmodifiable(_vouchers);

  List<TicketModel> getTickets() => List.unmodifiable(_tickets);
  List<TicketModel> get tickets => List.unmodifiable(_tickets);

  void toggleBalanceVisibility() {
    AppPreferences.toggleBalanceHidden();
    _wallet = _wallet.copyWith(isBalanceHidden: AppPreferences.balanceHiddenNotifier.value);
    walletNotifier.value = _wallet;
  }

  // ─── Real Supabase Data Synchronization ───────────────────────────────────

  /// Fetches latest profile, transactions, and notifications from Supabase.
  Future<void> fetchFromSupabase() async {
    final uid = activeUserId;
    try {
      // 1. Fetch Profile
      final profile = await SupabaseConfig.client
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();

      if (profile != null) {
        _user = UserModel.fromJson(profile);
        final balVal = profile['balance'];
        final parsedBal = balVal is num
            ? balVal.toInt()
            : int.tryParse(balVal?.toString() ?? '0') ?? _wallet.balance;
        _wallet = _wallet.copyWith(balance: parsedBal);
        walletNotifier.value = _wallet;
      }

      // 2. Fetch Transactions
      final txRows = await SupabaseConfig.client
          .from('transactions')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      if (txRows is List && txRows.isNotEmpty) {
        _transactions.clear();
        for (final row in txRows) {
          _transactions.add(TransactionModel.fromJson(row as Map<String, dynamic>));
        }
        transactionsNotifier.value = List.unmodifiable(_transactions);
      }

      // 3. Fetch Notifications
      final notifRows = await SupabaseConfig.client
          .from('notifications')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      if (notifRows is List && notifRows.isNotEmpty) {
        _notifications.clear();
        for (final row in notifRows) {
          _notifications.add(NotificationModel.fromJson(row as Map<String, dynamic>));
        }
        notificationsNotifier.value = List.unmodifiable(_notifications);
      }
    } catch (e) {
      debugPrint('Supabase fetch error (using offline fallback): $e');
    }
  }

  /// Syncs balance to Supabase profiles table in background.
  Future<void> _syncBalanceToSupabase(int newBalance) async {
    try {
      await SupabaseConfig.client.from('profiles').update({
        'balance': newBalance,
        'available_balance': newBalance,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', activeUserId);
    } catch (e) {
      debugPrint('Supabase balance sync error: $e');
    }
  }

  /// Saves transaction and emits a notification row in Supabase.
  Future<void> _saveTxToSupabase(TransactionModel tx) async {
    try {
      final uid = activeUserId;
      await SupabaseConfig.client
          .from('transactions')
          .insert(tx.toSupabaseMap(uid));

      // Auto-generate notification row for this transaction
      final notifMap = {
        'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
        'user_id': uid,
        'type': tx.isIncome ? 'money_received' : 'money_sent',
        'category': tx.category,
        'title': tx.title,
        'body': tx.isIncome
            ? 'You received +${tx.amount} MMK.'
            : 'You sent ${tx.amount} MMK.',
        'amount': tx.amount,
        'is_read': false,
        'date': 'Today',
        'time': tx.timestamp != null
            ? '${tx.timestamp!.hour.toString().padLeft(2, '0')}:${tx.timestamp!.minute.toString().padLeft(2, '0')}'
            : 'Just now',
      };
      await SupabaseConfig.client.from('notifications').insert(notifMap);
      _notifications.insert(0, NotificationModel.fromJson(notifMap));
      notificationsNotifier.value = List.unmodifiable(_notifications);
    } catch (e) {
      debugPrint('Supabase transaction save error: $e');
    }
  }

  // ─── Mutations ─────────────────────────────────────────────────────────────

  bool deductBalance(int amount) {
    if (_wallet.balance < amount) return false;
    _wallet = _wallet.copyWith(balance: _wallet.balance - amount);
    walletNotifier.value = _wallet;
    _syncBalanceToSupabase(_wallet.balance);
    return true;
  }

  void addBalance(int amount) {
    _wallet = _wallet.copyWith(balance: _wallet.balance + amount);
    walletNotifier.value = _wallet;
    _syncBalanceToSupabase(_wallet.balance);
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
    _saveTxToSupabase(tx);
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


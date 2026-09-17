import '../../core/utils/currency_formatter.dart';

class WalletModel {
  final int balance;
  final int points;
  final bool isBalanceHidden;

  const WalletModel({
    required this.balance,
    required this.points,
    this.isBalanceHidden = false,
  });

  String get formattedBalance => CurrencyFormatter.formatMMK(balance);

  WalletModel copyWith({
    int? balance,
    int? points,
    bool? isBalanceHidden,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      points: points ?? this.points,
      isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
    );
  }
}

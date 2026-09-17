enum TransactionType { inMoney, outMoney }

class TransactionModel {
  final String id;
  final String title;
  final String date;
  final int amount;
  final TransactionType type;
  final String category;
  final String status;
  final String? recipientOrMethod;
  final String? recipientAccount;
  final int fee;
  final String? note;
  final String? referenceNumber;
  final DateTime? timestamp;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    this.status = 'Completed',
    this.recipientOrMethod,
    this.recipientAccount,
    this.fee = 0,
    this.note,
    this.referenceNumber,
    this.timestamp,
  });

  bool get isIncome => type == TransactionType.inMoney;
}


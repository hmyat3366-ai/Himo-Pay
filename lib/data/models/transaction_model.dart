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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString().toLowerCase() ?? '';
    final isIncome = rawType == 'received' ||
        rawType == 'inmoney' ||
        rawType == 'income' ||
        rawType == 'deposit';

    final amtVal = json['amount'];
    final parsedAmt = amtVal is num
        ? amtVal.toInt()
        : int.tryParse(amtVal?.toString() ?? '0') ?? 0;

    final feeVal = json['fee'];
    final parsedFee = feeVal is num
        ? feeVal.toInt()
        : int.tryParse(feeVal?.toString() ?? '0') ?? 0;

    DateTime? parsedTime;
    if (json['created_at'] != null) {
      parsedTime = DateTime.tryParse(json['created_at'].toString());
    }

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Transaction',
      date: json['date']?.toString() ?? 'Today',
      amount: parsedAmt,
      type: isIncome ? TransactionType.inMoney : TransactionType.outMoney,
      category: json['category']?.toString() ?? 'Transfer',
      status: json['status']?.toString() ?? 'Completed',
      recipientOrMethod: json['counterparty']?.toString(),
      recipientAccount: json['counterparty_phone']?.toString(),
      fee: parsedFee,
      note: json['note']?.toString(),
      referenceNumber: json['id']?.toString(),
      timestamp: parsedTime,
    );
  }

  Map<String, dynamic> toSupabaseMap(String userId) {
    final now = timestamp ?? DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return {
      'id': id,
      'user_id': userId,
      'type': isIncome ? 'received' : 'sent',
      'amount': amount,
      'status': status.toLowerCase(),
      'title': title,
      'counterparty': recipientOrMethod ?? '',
      'counterparty_phone': recipientAccount,
      'date': date,
      'timestamp': timeStr,
      'fee': fee,
      'note': note,
      'payment_method': recipientOrMethod != null && recipientOrMethod!.isNotEmpty
          ? recipientOrMethod
          : 'Himo Wallet Balance',
      'category': category,
    };
  }
}


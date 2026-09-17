class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String category;
  final String title;
  final String body;
  final int? amount;
  final bool isRead;
  final String date;
  final String time;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.title,
    required this.body,
    this.amount,
    this.isRead = false,
    required this.date,
    required this.time,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final amtVal = json['amount'];
    final parsedAmt = amtVal is num
        ? amtVal.toInt()
        : int.tryParse(amtVal?.toString() ?? '');

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      category: json['category']?.toString() ?? 'Payments',
      title: json['title']?.toString() ?? 'Notification',
      body: json['body']?.toString() ?? '',
      amount: parsedAmt,
      isRead: json['is_read'] == true,
      date: json['date']?.toString() ?? 'Today',
      time: json['time']?.toString() ?? 'Just now',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'category': category,
      'title': title,
      'body': body,
      'amount': amount,
      'is_read': isRead,
      'date': date,
      'time': time,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? category,
    String? title,
    String? body,
    int? amount,
    bool? isRead,
    String? date,
    String? time,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      amount: amount ?? this.amount,
      isRead: isRead ?? this.isRead,
      date: date ?? this.date,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

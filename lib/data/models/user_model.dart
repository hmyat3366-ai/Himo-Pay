class UserModel {
  final String id;
  final String himoId;
  final String name;
  final String phone;
  final String maskedPhone;
  final String tier;
  final bool isApproved;
  final String referralCode;
  final String? avatarUrl;

  const UserModel({
    this.id = '',
    this.himoId = '',
    required this.name,
    required this.phone,
    required this.maskedPhone,
    required this.tier,
    required this.isApproved,
    required this.referralCode,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final phone = json['phone']?.toString() ?? '';
    final cleanDigits = phone.replaceAll(RegExp(r'\D'), '');
    final last4 = cleanDigits.length >= 4
        ? cleanDigits.substring(cleanDigits.length - 4)
        : cleanDigits;
    final masked = last4.isNotEmpty ? '*******$last4' : '*******';

    return UserModel(
      id: json['id']?.toString() ?? '',
      himoId: json['himo_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Himo User',
      phone: phone,
      maskedPhone: masked,
      tier: (json['kyc_status'] == 'verified') ? 'Subscriber Level 2' : 'Basic Member',
      isApproved: json['kyc_status'] == 'verified',
      referralCode: json['himo_id']?.toString() ?? 'HM-REF',
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'himo_id': himoId,
      'name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'kyc_status': isApproved ? 'verified' : 'pending',
    };
  }

  UserModel copyWith({
    String? id,
    String? himoId,
    String? name,
    String? phone,
    String? maskedPhone,
    String? tier,
    bool? isApproved,
    String? referralCode,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      himoId: himoId ?? this.himoId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      maskedPhone: maskedPhone ?? this.maskedPhone,
      tier: tier ?? this.tier,
      isApproved: isApproved ?? this.isApproved,
      referralCode: referralCode ?? this.referralCode,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

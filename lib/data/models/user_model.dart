class UserModel {
  final String name;
  final String phone;
  final String maskedPhone;
  final String tier;
  final bool isApproved;
  final String referralCode;

  const UserModel({
    required this.name,
    required this.phone,
    required this.maskedPhone,
    required this.tier,
    required this.isApproved,
    required this.referralCode,
  });
}

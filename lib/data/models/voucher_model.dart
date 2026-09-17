class VoucherModel {
  final String code;
  final String title;
  final String tag;
  final String validity;
  final String places;
  final String description;
  final int points;
  final bool isClaimed;

  const VoucherModel({
    required this.code,
    required this.title,
    required this.tag,
    required this.validity,
    required this.places,
    required this.description,
    this.points = 0,
    this.isClaimed = false,
  });
}

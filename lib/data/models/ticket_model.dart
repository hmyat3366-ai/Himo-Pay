enum TicketType {
  event,
  movie,
  transit,
}

class TicketModel {
  final String id;
  final String title;
  final String subtitle;
  final String venue;
  final String date;
  final String time;
  final String seat;
  final String status;
  final TicketType type;
  final String code;

  const TicketModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.venue,
    required this.date,
    this.time = '',
    required this.seat,
    this.status = 'Active Pass',
    this.type = TicketType.event,
    this.code = '',
  });
}

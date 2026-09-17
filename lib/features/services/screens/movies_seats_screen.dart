import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/himo_repository.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/ticket_model.dart';

class MoviesSeatsScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const MoviesSeatsScreen({super.key, this.data});

  @override
  State<MoviesSeatsScreen> createState() => _MoviesSeatsScreenState();
}

class _MoviesSeatsScreenState extends State<MoviesSeatsScreen> {
  final HimoRepository _repo = HimoRepository();
  final Set<String> _selectedSeats = {'C3', 'C4'};
  final Set<String> _occupiedSeats = {'A1', 'A2', 'B4', 'B5', 'D2', 'D3'};
  String _selectedTime = '4:30 PM';

  final List<String> _rows = ['A', 'B', 'C', 'D', 'E'];
  final int _cols = 6;

  void _bookSeats(String title, String cinema, int price) {
    if (_selectedSeats.isEmpty) {
      HimoToast.show(context, 'Please select at least one seat'.tr('ကျေးဇူးပြု၍ ထိုင်ခုံ အနည်းဆုံး တစ်ခု ရွေးပါ'), isError: true);
      return;
    }

    final total = _selectedSeats.length * price;
    if (_repo.balance < total) {
      HimoToast.show(context, 'Insufficient balance in wallet'.tr('ပိုက်ဆံအိတ် လက်ကျန်ငွေ မလုံလောက်ပါ'), isError: true);
      return;
    }

    final ticketCode = 'CIN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final seatStr = _selectedSeats.toList()..sort();

    _repo.deductBalance(total);
    _repo.addPoints((total / 500).round());
    _repo.addTransaction(
      TransactionModel(
        id: 'HM-CN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: '$title Movie Ticket',
        date: 'Just now'.tr('ယခုလေးတင်'),
        amount: total,
        type: TransactionType.outMoney,
        category: 'Cinema Ticket',
      ),
    );

    _repo.addTicket(
      TicketModel(
        id: ticketCode,
        title: title,
        venue: cinema,
        date: 'Today • $_selectedTime',
        type: TicketType.movie,
        code: ticketCode,
        seat: seatStr.join(', '),
      ),
    );

    Navigator.of(context).pushReplacementNamed(
      '/movies-success',
      arguments: {
        'title': title,
        'cinema': cinema,
        'time': _selectedTime,
        'seats': seatStr.join(', '),
        'total': total,
        'code': ticketCode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.data?['title'] ?? 'Inception: IMAX 70mm';
    final cinema = widget.data?['cinema'] ?? 'JCGV Junction City • Hall 1';
    final price = (widget.data?['price'] as num?)?.toInt() ?? 11000;
    final times = (widget.data?['times'] as List<String>?) ?? ['1:00 PM', '4:30 PM', '7:45 PM'];

    final total = _selectedSeats.length * price;

    return Scaffold(
      appBar: HimoAppBar(title: title),
      body: SafeArea(
        child: Column(
          children: [
            // Showtime picker
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: times.map((t) {
                  final isSel = _selectedTime == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: isSel,
                      onSelected: (val) => setState(() => _selectedTime = t),
                      selectedColor: AppColors.primaryGold,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSel ? Colors.black : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Screen arc indicator
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              height: 24,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.primaryGold.withOpacity(0.8), width: 3),
                ),
              ),
              child: Center(
                child: Text('CINEMA SCREEN'.tr('ရုပ်ရှင် ပိတ်ကား'), style: TextStyle(fontSize: 10, letterSpacing: 4, color: AppColors.gray500, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 20),
            // Seat Map
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  ..._rows.map((row) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            child: Text(row, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.gray500)),
                          ),
                          const SizedBox(width: 8),
                          ...List.generate(_cols, (colIdx) {
                            final seatId = '$row${colIdx + 1}';
                            final isOccupied = _occupiedSeats.contains(seatId);
                            final isSelected = _selectedSeats.contains(seatId);

                            Color bgColor;
                            Color borderColor;
                            if (isOccupied) {
                              bgColor = isDark ? Colors.white12 : AppColors.gray300;
                              borderColor = Colors.transparent;
                            } else if (isSelected) {
                              bgColor = AppColors.primaryGold;
                              borderColor = AppColors.primaryGold;
                            } else {
                              bgColor = Colors.transparent;
                              borderColor = isDark ? AppColors.borderDark : AppColors.gray400;
                            }

                            return GestureDetector(
                              onTap: isOccupied
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedSeats.remove(seatId);
                                        } else {
                                          _selectedSeats.add(seatId);
                                        }
                                      });
                                    },
                              child: Container(
                                width: 34,
                                height: 34,
                                margin: EdgeInsets.only(
                                  left: colIdx == 3 ? 18 : 4,
                                  right: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor, width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${colIdx + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Colors.black
                                          : (isOccupied ? Colors.white38 : (isDark ? Colors.white70 : Colors.black87)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  // Seat Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend(AppColors.primaryGold, 'Selected'.tr('ရွေးထားသည်')),
                      const SizedBox(width: 16),
                      _buildLegend(isDark ? AppColors.borderDark : AppColors.gray400, 'Available'.tr('အားသည်'), isBorder: true),
                      const SizedBox(width: 16),
                      _buildLegend(isDark ? Colors.white12 : AppColors.gray300, 'Occupied'.tr('လူပြည့်')),
                    ],
                  ),
                ],
              ),
            ),
            // Checkout bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.gray200)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${'Seats:'.tr('ထိုင်ခုံ:')} ${_selectedSeats.isEmpty ? 'None'.tr('မရွေးရသေးပါ') : _selectedSeats.join(', ')}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          Text(cinema, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                        ],
                      ),
                      Text(CurrencyFormatter.formatMMK(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  HimoButton(
                    text: 'Confirm Booking • '.tr('လက်မှတ်ဝယ်ယူမည် • ') + CurrencyFormatter.formatMMK(total),
                    onPressed: _selectedSeats.isEmpty ? null : () => _bookSeats(title, cinema, price),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label, {bool isBorder = false}) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isBorder ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(4),
            border: isBorder ? Border.all(color: color, width: 1.5) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.gray500, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

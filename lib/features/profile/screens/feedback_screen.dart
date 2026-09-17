import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_card.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 5;
  String _selectedTopic = 'App Performance';
  final TextEditingController _textController = TextEditingController();

  final List<String> _topics = [
    'App Performance',
    'UI & Aesthetics',
    'Transfer Speed',
    'New Features',
    'Bug Report',
  ];

  void _submitFeedback() {
    if (_textController.text.trim().isEmpty) {
      HimoToast.show(context, 'Please share a brief comment or suggestion', isError: true);
      return;
    }

    HimoToast.show(context, '🙏 Thank you! Your feedback helps make Himo Pay better.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HimoAppBar(title: 'Feedback & Suggestions'.tr('အကြံပြုချက်နှင့် သုံးသပ်ချက်')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            HimoCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Rate Your Experience'.tr('အသုံးပြုမှု အတွေ့အကြုံကို အဆင့်သတ်မှတ်ပါ'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('How satisfied are you with Himo Pay?'.tr('Himo Pay အပေါ် မည်မျှ စိတ်ကျေနပ်မှု ရှိပါသလဲ?'), style: TextStyle(fontSize: 12, color: AppColors.gray500)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (idx) {
                      final star = idx + 1;
                      return IconButton(
                        icon: Icon(
                          star <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: AppColors.primaryGold,
                          size: 36,
                        ),
                        onPressed: () => setState(() => _rating = star),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('FEEDBACK CATEGORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _topics.map((t) {
                final isSelected = _selectedTopic == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTopic = t);
                  },
                  selectedColor: AppColors.primaryGold,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text('YOUR COMMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceElevatedDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Tell us what you love or what we can improve...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 28),
            HimoButton(
              text: 'Submit Feedback'.tr('အကြံပြုချက် ပေးပို့မည်'),
              onPressed: _submitFeedback,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';

class KycIdentityScreen extends StatefulWidget {
  const KycIdentityScreen({super.key});

  @override
  State<KycIdentityScreen> createState() => _KycIdentityScreenState();
}

class _KycIdentityScreenState extends State<KycIdentityScreen> {
  String _selectedId = 'nrc';

  final List<Map<String, String>> _idTypes = [
    {'id': 'nrc', 'title': 'Myanmar NRC', 'icon': '🪪', 'desc': 'National Registration Card'},
    {'id': 'passport', 'title': 'Passport', 'icon': '📕', 'desc': 'International Travel Passport'},
    {'id': 'driving', 'title': 'Driving License', 'icon': '🚗', 'desc': 'Myanmar Driver Card'},
    {'id': 'other', 'title': 'Other Government ID', 'icon': '📄', 'desc': 'Official document'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HimoAppBar(title: 'Identity Type'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Document Type',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.gray900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Select your government-issued identification document to verify your Level 2 account.',
                style: TextStyle(fontSize: 13, color: AppColors.gray500),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ID Cards Grid
              Expanded(
                child: ListView.separated(
                  itemCount: _idTypes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _idTypes[index];
                    final isSelected = _selectedId == item['id'];

                    return InkWell(
                      onTap: () => setState(() => _selectedId = item['id']!),
                      borderRadius: AppRadius.cardBorder,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.12)
                              : (isDark ? AppColors.surfaceCardDark : Colors.white),
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.gray200,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(item['icon']!, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : AppColors.gray900,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['desc']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? AppColors.primary : AppColors.gray300,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              HimoButton(
                text: 'Next: Upload Documents',
                onPressed: () {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  Navigator.of(context).pushNamed(
                    '/kyc-verify',
                    arguments: args,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

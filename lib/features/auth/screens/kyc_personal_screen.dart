import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';

class KycPersonalScreen extends StatefulWidget {
  const KycPersonalScreen({super.key});

  @override
  State<KycPersonalScreen> createState() => _KycPersonalScreenState();
}

class _KycPersonalScreenState extends State<KycPersonalScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'HTET MYAT OO');
  final TextEditingController _nrcController = TextEditingController(text: '12/DAGAMA(N)048291');
  final TextEditingController _dobController = TextEditingController(text: '14/08/1998');
  String _selectedGender = 'male';

  @override
  void dispose() {
    _nameController.dispose();
    _nrcController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HimoAppBar(title: 'Personal Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.gray900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Please enter your legal name as shown on your NRC or Passport.',
                style: TextStyle(fontSize: 13, color: AppColors.gray500),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Full Name
              _buildFieldLabel('Full Name', isDark),
              _buildTextField(_nameController, 'Your Full Name', isDark),
              const SizedBox(height: AppSpacing.lg),

              // NRC Number
              _buildFieldLabel('NRC Number / Identity', isDark),
              _buildTextField(_nrcController, '12/xxx(N)xxxxxx', isDark),
              const SizedBox(height: AppSpacing.lg),

              // Date of Birth
              _buildFieldLabel('Date of Birth', isDark),
              _buildTextField(_dobController, 'DD/MM/YYYY', isDark),
              const SizedBox(height: AppSpacing.lg),

              // Gender
              _buildFieldLabel('Gender', isDark),
              Row(
                children: [
                  _buildGenderOption('male', 'Male', isDark),
                  const SizedBox(width: 12),
                  _buildGenderOption('female', 'Female', isDark),
                  const SizedBox(width: 12),
                  _buildGenderOption('other', 'Other', isDark),
                ],
              ),
              const SizedBox(height: AppSpacing.hero),

              HimoButton(
                text: 'Next: Identity Documents',
                onPressed: () {
                  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                  final phone = args?['phone']?.toString() ?? '09950786548';
                  final name = _nameController.text.trim();
                  Navigator.of(context).pushNamed(
                    '/kyc-identity',
                    arguments: {
                      'phone': phone,
                      'name': name.isNotEmpty ? name : 'HTET MYAT OO',
                      'nrc': _nrcController.text.trim(),
                      'dob': _dobController.text.trim(),
                      'gender': _selectedGender,
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.gray300 : AppColors.gray700,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceCardDark : Colors.white,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.gray900,
        ),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: AppColors.gray400),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, bool isDark) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedGender = value),
        borderRadius: AppRadius.cardBorder,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : (isDark ? AppColors.surfaceCardDark : Colors.white),
            borderRadius: AppRadius.cardBorder,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.gray200,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primaryDark : (isDark ? Colors.white : AppColors.gray700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

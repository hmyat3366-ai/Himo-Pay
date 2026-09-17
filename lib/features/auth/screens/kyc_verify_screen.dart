import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_app_bar.dart';
import '../../../core/widgets/himo_toast.dart';

class KycVerifyScreen extends StatefulWidget {
  const KycVerifyScreen({super.key});

  @override
  State<KycVerifyScreen> createState() => _KycVerifyScreenState();
}

class _KycVerifyScreenState extends State<KycVerifyScreen> {
  bool _frontUploaded = false;
  bool _backUploaded = false;

  void _uploadDoc(bool isFront) {
    setState(() {
      if (isFront) {
        _frontUploaded = true;
      } else {
        _backUploaded = true;
      }
    });
    HimoToast.show(context, '${isFront ? "Front" : "Back"} side document uploaded successfully');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const HimoAppBar(title: 'Upload Documents'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Capture Identification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.gray900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Please take a clear photo of the front and back of your Myanmar NRC.',
                style: TextStyle(fontSize: 13, color: AppColors.gray500),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Front Document Box
              _buildUploadBox(
                title: 'Front Side of ID',
                isUploaded: _frontUploaded,
                onTap: () => _uploadDoc(true),
                isDark: isDark,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Back Document Box
              _buildUploadBox(
                title: 'Back Side of ID',
                isUploaded: _backUploaded,
                onTap: () => _uploadDoc(false),
                isDark: isDark,
              ),

              const Spacer(),

              // Security notice
              Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: AppColors.primaryDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your data is securely encrypted under Central Bank of Myanmar regulations.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              HimoButton(
                text: 'Confirm & Continue',
                onPressed: () {
                  Navigator.of(context).pushNamed('/create-passcode');
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardBorder,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isUploaded
              ? AppColors.successBg
              : (isDark ? AppColors.surfaceCardDark : Colors.white),
          borderRadius: AppRadius.cardBorder,
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.gray300,
            width: isUploaded ? 1.5 : 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.camera_alt_outlined,
              size: 32,
              color: isUploaded ? AppColors.success : AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              isUploaded ? '$title (Uploaded ✓)' : title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isUploaded ? AppColors.success : (isDark ? Colors.white : AppColors.gray900),
              ),
            ),
            if (!isUploaded)
              const Text(
                'Tap to photograph or select image',
                style: TextStyle(fontSize: 11, color: AppColors.gray400),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_logo.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Background Lifestyle Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/campaign_photo_cafe.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.surfaceDark);
              },
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.45, 0.85],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Branding
                  const HimoPayLogo(height: 32, variant: LogoVariant.dark),

                  const Spacer(),

                  // Hero Text
                  const Text(
                    'Everyday Payments,\nEffortlessly Rewarded.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Experience modern Myanmar financial services with instant P2P transfers, contactless QR, and premium rewards.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray300,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Action Buttons
                  HimoButton(
                    text: 'Sign In',
                    onPressed: () => Navigator.of(context).pushNamed('/login-phone'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  HimoButton(
                    text: 'Create New Account',
                    isPrimary: false,
                    backgroundColor: Colors.white.withOpacity(0.12),
                    textColor: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/signup-phone'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

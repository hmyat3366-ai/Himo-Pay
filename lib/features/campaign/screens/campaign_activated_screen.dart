import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';

class CampaignActivatedScreen extends StatelessWidget {
  const CampaignActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGold.withOpacity(0.15),
                  border: Border.all(color: AppColors.primaryGold, width: 2),
                ),
                child: const Icon(Icons.bolt_rounded, color: AppColors.primaryGold, size: 52),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booster Activated!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
              ),
              const SizedBox(height: 10),
              const Text(
                'You have unlocked 2X Himo Points for all QR payments made this weekend! +200 Welcome Bonus Points added to your wallet.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars_rounded, color: AppColors.primaryGold, size: 24),
                    SizedBox(width: 10),
                    Text(
                      '+200 Points Credited',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryGold),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              HimoButton(
                text: 'Scan to Pay Now',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/scan-qr');
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

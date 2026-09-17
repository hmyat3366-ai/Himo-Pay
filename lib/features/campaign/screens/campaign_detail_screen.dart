import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../data/repositories/himo_repository.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Campaign Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/event_visual_rewards.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'HIMO × PARTNER PROGRAMME',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryGold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Weekend Rewards: Earn 2X Points on QR Payments',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enjoy double membership rewards every Saturday and Sunday when you scan to pay with Himo Pay at over 5,000+ participating merchants nationwide.',
                    style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  const Text('CAMPAIGN HIGHLIGHTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryGold)),
                  const SizedBox(height: 14),
                  _buildHighlight(Icons.stars_rounded, 'Double points on all merchant checkout transactions.'),
                  _buildHighlight(Icons.percent_rounded, 'Up to 15% instant cashback at partner restaurants.'),
                  _buildHighlight(Icons.card_giftcard_rounded, 'Automatic entry into the 100,000,000 MMK Gold Rush Lucky Draw.'),
                  _buildHighlight(Icons.event_available_rounded, 'Active every weekend through December 2026.'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF141414),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: HimoButton(
                text: '⚡ Activate Reward Booster',
                onPressed: () {
                  HimoRepository().addPoints(200);
                  Navigator.of(context).pushReplacementNamed('/campaign-activated');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlight(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white, height: 1.4))),
        ],
      ),
    );
  }
}

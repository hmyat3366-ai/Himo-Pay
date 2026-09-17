import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/widgets/himo_logo.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/wallet_model.dart';

/// HimoDebitWalletCard
/// Executive Digital Fintech Card & Action Dock
/// Purpose-built digital balance card:
/// 1. Sleek executive matte dark finish (clean luxury gradient & subtle sheen)
/// 2. HimoPay Brand Identity on top-left
/// 3. "Scan Me" QR shortcut on top-right (opens /my-qr)
/// 4. High-impact Available Balance with Privacy Eye Toggle
/// 5. Integrated Loyalty & Rewards Strip (Member tier & points with "Explore More >")
/// 6. Dedicated 3-column Action Dock (Transfer, Cash In, Cash Out)
class HimoDebitWalletCard extends StatelessWidget {
  final WalletModel wallet;
  final UserModel user;
  final bool isDark;
  final VoidCallback onToggleBalance;
  final VoidCallback onTransfer;
  final VoidCallback onCashIn;
  final VoidCallback onCashOut;
  final VoidCallback onScanMe;
  final VoidCallback onExploreMore;

  const HimoDebitWalletCard({
    super.key,
    required this.wallet,
    required this.user,
    required this.isDark,
    required this.onToggleBalance,
    required this.onTransfer,
    required this.onCashIn,
    required this.onCashOut,
    required this.onScanMe,
    required this.onExploreMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. The Executive Digital Card ──
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B202A), // Executive Matte Charcoal
                Color(0xFF131720),
                Color(0xFF0D1017), // Deep Obsidian Base
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 32,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Stack(
              children: [
                // Ambient Brand Specular Glow (Top Right)
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Subtle Diagonal Micro Sheen Pattern (Bottom Left)
                Positioned(
                  bottom: -50,
                  left: -30,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Card Content
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Top Row: HimoPay Brand Logo ──
                      const HimoPayLogo(height: 24, variant: LogoVariant.dark),
                      const SizedBox(height: 18),

                      // ── Main Section: Balance (Left) & Scan Me QR (Right) - Image 3 Layout ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Left Column: Available Balance Label + Amount & Eye Icon
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.availableBalance,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.68),
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        wallet.isBalanceHidden ? '•••••••• MMK' : wallet.formattedBalance,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -0.8,
                                          height: 1.1,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: onToggleBalance,
                                      behavior: HitTestBehavior.opaque,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          wallet.isBalanceHidden
                                              ? Icons.visibility_off_rounded
                                              : Icons.visibility_rounded,
                                          size: 18,
                                          color: Colors.white.withOpacity(0.75),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Right Column: "Scan Me" Label + Dedicated Square QR Box (Image 3)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Scan Me'.tr('စကင်ဖတ်ရန်'),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: -0.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: onScanMe,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.18),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.qr_code_2_rounded,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Bottom: Loyalty & Rewards Strip ──
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.09),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Member Tier & Points with Luxury Emblem
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.stars_rounded,
                                    size: 15,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 12.5, color: Colors.white),
                                    children: [
                                      TextSpan(
                                        text: '${user.tier.isNotEmpty ? (user.tier.contains("Level") ? "Subscriber".tr("အသုံးပြုသူ") : "Member".tr("အသင်းဝင်")) : "Member".tr("အသင်းဝင်")}  ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(0.72),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${wallet.points} ${AppStrings.points}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // "Explore More >" Action Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onExploreMore,
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Explore More'.tr('အသေးစိတ်'),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(0.92),
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        size: 14,
                                        color: Colors.white.withOpacity(0.75),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── 2. Primary Financial Actions Dock ──
        Row(
          children: [
            _buildActionButton(
              context: context,
              title: AppStrings.transfer,
              icon: Icons.swap_horiz_rounded,
              onTap: onTransfer,
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _buildActionButton(
              context: context,
              title: AppStrings.cashIn,
              icon: Icons.arrow_downward_rounded,
              onTap: onCashIn,
              isDark: isDark,
            ),
            const SizedBox(width: 10),
            _buildActionButton(
              context: context,
              title: AppStrings.cashOut,
              icon: Icons.arrow_upward_rounded,
              onTap: onCashOut,
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : AppColors.gray200,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.25)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.charcoalText,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

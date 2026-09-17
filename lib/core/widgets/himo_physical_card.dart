import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../localization/app_strings.dart';
import '../utils/currency_formatter.dart';

/// HimoPhysicalCard
/// A realistic, executive matte titanium/platinum physical payment card
/// with 3D Flip Animation (tap to view back side with CVV, Magnetic Stripe, Expiry).
class HimoPhysicalCard extends StatefulWidget {
  final String cardHolder;
  final String? cardNumber;
  final String? bankName;
  final String cardType;
  final String tier;
  final int? balance;
  final String? balanceText;
  final String? balanceLabel;
  final bool initialBalanceVisible;
  final VoidCallback? onTap;

  const HimoPhysicalCard({
    super.key,
    this.cardHolder = 'ROBIN HOLESINSKY',
    this.cardNumber,
    this.bankName,
    this.cardType = 'VISA',
    this.tier = 'Platinum',
    this.balance,
    this.balanceText,
    this.balanceLabel,
    this.initialBalanceVisible = true,
    this.onTap,
  });

  @override
  State<HimoPhysicalCard> createState() => _HimoPhysicalCardState();
}

class _HimoPhysicalCardState extends State<HimoPhysicalCard>
    with SingleTickerProviderStateMixin {
  late bool _isBalanceVisible;
  bool _isCvvVisible = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _isBalanceVisible = widget.initialBalanceVisible;
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _handleCardTap() {
    HapticFeedback.selectionClick();
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final displayBalance = widget.balanceText ??
        (widget.balance != null
            ? CurrencyFormatter.formatMMK(widget.balance!)
            : '3,850,000 MMK');

    final displayLabel = widget.balanceLabel ?? 'CARD BALANCE'.tr('ကတ်လက်ကျန်ငွေ');

    return GestureDetector(
      onTap: _handleCardTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final isFront = angle < (pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angle),
            child: Container(
              width: double.infinity,
              height: 188,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // Warm Brushed Titanium / Platinum Metallic Finish
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8D8A83), // Warm platinum highlight
                    Color(0xFF75726B), // Matte titanium mid
                    Color(0xFF56534D), // Deep brushed titanium base
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
                border: Border.all(
                  color: const Color(0xFFA5A29A).withValues(alpha: 0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.12),
                    blurRadius: 2,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: isFront
                    ? _buildFrontFace(displayBalance, displayLabel)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _buildBackFace(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontFace(String displayBalance, String displayLabel) {
    return Stack(
      children: [
        // Specular Glow Reflection (Top Left)
        Positioned(
          top: -35,
          left: -25,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Subtle Diagonal Metallic Brushed Sheen
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-1.0, -0.6),
                end: const Alignment(1.0, 0.6),
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Bank Label & Contactless Symbol
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.bankName != null && widget.bankName!.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_rounded,
                            size: 14,
                            color: Color(0xFF2C2A26),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.bankName!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                                color: Color(0xFF262420),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'TAP TO FLIP'.tr('လှန်ကြည့်ရန် နှိပ်ပါ'),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF333029),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const ContactlessWaveIcon(
                        color: Color(0xFF1E1D19),
                        size: 26,
                      ),
                    ],
                  ),
                ],
              ),

              // Middle Section: Masked Number & Card Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.cardNumber != null && widget.cardNumber!.isNotEmpty)
                    Text(
                      widget.cardNumber!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: Color(0xFF2B2925),
                      ),
                    ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: Color(0xFF403D37),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                _isBalanceVisible ? displayBalance : '•••••••• MMK',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.2,
                                  color: Color(0xFF141310),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _isBalanceVisible = !_isBalanceVisible;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 16,
                                    color: const Color(0xFF2E2B25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Bottom Row: Cardholder Name & Card Network Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.cardHolder.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                            color: Color(0xFF1A1916),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.cardType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -0.4,
                          color: Color(0xFF161512),
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.tier,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: Color(0xFF2D2B26),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackFace() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        // Magnetic Stripe
        Container(
          width: double.infinity,
          height: 36,
          color: const Color(0xFF121210),
        ),
        const SizedBox(height: 12),

        // Signature & CVV Panel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Signature Box
              Expanded(
                flex: 4,
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE7DE),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFCBC4B7)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.cardHolder.toLowerCase(),
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'serif',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22201D),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // CVV Box
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _isCvvVisible = !_isCvvVisible);
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2A25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isCvvVisible ? '892' : '•••',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _isCvvVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 12,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Metadata footer
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'EXPIRES END: 09/29',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: Color(0xFF1E1D19),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '24/7 HELPLINE: 1800-HIMO-PAY'.tr('အကူအညီ: 1800-HIMO-PAY'),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B3831),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB5B2AB), Color(0xFF8A8780)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white38),
                ),
                child: const Text(
                  'HOLOGRAM SECURE',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Color(0xFF1E1D1A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom Contactless Wave Icon (3 concentric wave arcs curving to right: `)))`)
class ContactlessWaveIcon extends StatelessWidget {
  final Color color;
  final double size;

  const ContactlessWaveIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.75, size),
      painter: _ContactlessPainter(color),
    );
  }
}

class _ContactlessPainter extends CustomPainter {
  final Color color;

  _ContactlessPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.1, size.height * 0.5);

    // 3 concentric wave arcs
    for (int i = 1; i <= 3; i++) {
      final radius = (size.height * 0.26) * (i * 0.45);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -0.70, // ~ -40 degrees
        1.40,  // ~ 80 degrees sweep
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

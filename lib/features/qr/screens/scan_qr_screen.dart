import 'package:flutter/material.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/himo_button.dart';
import '../../../core/widgets/himo_toast.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _laserAnim;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnim = Tween<double>(begin: 0.0, end: 240.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _scanMerchant(String name, int amount, String branch) {
    Navigator.of(context).pushNamed(
      '/scan-payment-detail',
      arguments: {
        'merchantName': name,
        'amount': amount,
        'branch': branch,
        'points': (amount / 500).round(),
      },
    );
  }

  void _manualIdPrompt() {
    final controller = TextEditingController(text: 'RTH-YGN-04');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text('Enter Merchant ID'.tr('ဆိုင် ID ရိုက်ထည့်ပါ'), style: TextStyle(color: Colors.white, fontSize: 17)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g. RTH-YGN-04',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryGold)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'.tr('မလုပ်တော့ပါ'), style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold),
            onPressed: () {
              Navigator.pop(ctx);
              _scanMerchant('Rangoon Tea House', 18500, 'Table #04 • Downtown');
            },
            child: Text('Proceed'.tr('ဆက်လုပ်မည်'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

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
        title: Text(
          'Scan QR Code'.tr('QR ကုဒ် စကင်ဖတ်ပါ'),
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 24),
            onPressed: () => Navigator.of(context).pushNamed('/my-qr'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Align merchant or personal QR code inside frame'.tr('ဆိုင် သို့မဟုတ် မိတ်ဆွေ၏ QR ကုဒ်ကို ဘောင်အတွင်း ထားပါ'),
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const Spacer(),
            // Scanner Viewport
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                  ),
                  // Animated laser line
                  AnimatedBuilder(
                    animation: _laserAnim,
                    builder: (context, child) {
                      return Positioned(
                        top: 10 + _laserAnim.value,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, AppColors.primaryGold, Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGold.withOpacity(0.8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Corner brackets
                  _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),
                  _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),
                  _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
                  _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
                  // Viewfinder control buttons: Flashlight & Gallery
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCircleBtn(
                          icon: _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                          isActive: _isTorchOn,
                          onTap: () {
                            setState(() => _isTorchOn = !_isTorchOn);
                            HimoToast.show(context, _isTorchOn ? 'Flashlight ON' : 'Flashlight OFF');
                          },
                        ),
                        const SizedBox(width: 24),
                        _buildCircleBtn(
                          icon: Icons.image_outlined,
                          isActive: false,
                          onTap: () {
                            HimoToast.show(context, 'QR code detected from gallery');
                            _scanMerchant('City Mart Supermarket', 34200, 'Marketplace Junction City');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Simulation Triggers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  HimoButton(
                    text: '⚡ Scan: Rangoon Tea House (18,500 MMK)',
                    onPressed: () => _scanMerchant('Rangoon Tea House', 18500, 'Downtown Branch • Table #04'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      HimoToast.show(context, 'Invalid or Expired QR Code', isError: true);
                    },
                    child: const Text('⚡ Test Invalid / Expired QR Error'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _manualIdPrompt,
                    child: Text(
                      'Enter QR / Merchant ID Manually'.tr('QR / ဆိုင် ID ကိုယ်တိုင် ရိုက်ထည့်မည်'),
                      style: TextStyle(color: AppColors.primaryGold, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right, required bool isTop, required bool isLeft}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppColors.primaryGold, width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppColors.primaryGold, width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppColors.primaryGold, width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppColors.primaryGold, width: 4) : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            topRight: isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
            bottomLeft: !isTop && isLeft ? const Radius.circular(14) : Radius.zero,
            bottomRight: !isTop && !isLeft ? const Radius.circular(14) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleBtn({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.primaryGold : Colors.white.withOpacity(0.15),
        ),
        child: Icon(icon, color: isActive ? Colors.black : Colors.white, size: 22),
      ),
    );
  }
}

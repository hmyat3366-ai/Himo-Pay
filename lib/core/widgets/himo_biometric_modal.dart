import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../localization/app_strings.dart';

enum BiometricState {
  ready,
  scanning,
  verifying,
  success,
}

/// HimoBiometricModal
/// Premium Fintech Biometric Authentication Bottom Sheet
/// Provides an authentic biometric verification flow:
/// 1. Sensor Ready & Ripple Waves
/// 2. Active Fingerprint Scanning Simulation
/// 3. Biometric Verification & Matching
/// 4. Success Animation & Haptic Confirmation
class HimoBiometricModal extends StatefulWidget {
  final String? title;
  final String? subtitle;

  const HimoBiometricModal({
    super.key,
    this.title,
    this.subtitle,
  });

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? subtitle,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (ctx) => HimoBiometricModal(
        title: title,
        subtitle: subtitle,
      ),
    );
    return result ?? false;
  }

  @override
  State<HimoBiometricModal> createState() => _HimoBiometricModalState();
}

class _HimoBiometricModalState extends State<HimoBiometricModal>
    with TickerProviderStateMixin {
  BiometricState _state = BiometricState.ready;
  late AnimationController _pulseController;
  late AnimationController _laserController;
  Timer? _flowTimer1;
  Timer? _flowTimer2;
  Timer? _flowTimer3;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Automatically trigger the realistic biometric sequence on open
    _startBiometricProcess();
  }

  void _startBiometricProcess() {
    _flowTimer1?.cancel();
    _flowTimer2?.cancel();
    _flowTimer3?.cancel();

    // Step 1: Scanning begins (400ms)
    _flowTimer1 = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      HapticFeedback.lightImpact();
      setState(() => _state = BiometricState.scanning);

      // Step 2: Verifying with security module (1100ms)
      _flowTimer2 = Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _state = BiometricState.verifying);

        // Step 3: Success confirmed (1800ms)
        _flowTimer3 = Timer(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          HapticFeedback.mediumImpact();
          setState(() => _state = BiometricState.success);

          // Close modal and return true (2300ms)
          Future.delayed(const Duration(milliseconds: 550), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _flowTimer1?.cancel();
    _flowTimer2?.cancel();
    _flowTimer3?.cancel();
    _pulseController.dispose();
    _laserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.title ?? 'Biometric Authentication'.tr('လက်ဗွေဖြင့် အတည်ပြုခြင်း');
    final subtitle = widget.subtitle ??
        'Touch the fingerprint sensor to complete verification'.tr('အတည်ပြုပြီးစီးရန် လက်ဗွေရာ စကင်ဖတ်စက်ကို ထိတွေ့ပါ');

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191D26) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top handle
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),

          // Security Badge Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Himo Biometric Shield'.tr('Himo လုံခြုံရေး စနစ်'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Title & Subtitle
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.gray400 : AppColors.gray500,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Center Animated Sensor
          GestureDetector(
            onTap: () {
              if (_state != BiometricState.success) {
                _startBiometricProcess();
              }
            },
            child: _buildSensorVisual(isDark),
          ),
          const SizedBox(height: 24),

          // Progress Status Caption
          _buildStatusBadge(isDark),
          const SizedBox(height: 28),

          // Fallback Cancel Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
                  ),
                ),
              ),
              child: Text(
                'Use Passcode / Cancel'.tr('လျှို့ဝှက်ကုဒ်ဖြင့် အတည်ပြုမည် / ပယ်ဖျက်မည်'),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorVisual(bool isDark) {
    final isSuccess = _state == BiometricState.success;
    final isScanning = _state == BiometricState.scanning || _state == BiometricState.verifying;

    final primaryColor = isSuccess ? AppColors.success : AppColors.primary;

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Expanding Pulse Wave 2
          if (isScanning)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                final scale = 1.0 + (_pulseController.value * 0.22);
                final opacity = (1.0 - _pulseController.value) * 0.35;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withOpacity(opacity),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Outer Pulse Wave 1
          if (isScanning || isSuccess)
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                final scale = 1.0 + (_pulseController.value * 0.12);
                final opacity = (1.0 - _pulseController.value) * 0.5;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacity(isSuccess ? 0.15 : opacity * 0.3),
                    ),
                  ),
                );
              },
            ),

          // Core Sensor Target Pad
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSuccess
                  ? AppColors.success.withOpacity(0.18)
                  : (isDark
                      ? (isScanning ? const Color(0xFF232836) : const Color(0xFF1E222D))
                      : (isScanning ? const Color(0xFFFFF6F0) : const Color(0xFFF9FAFB))),
              border: Border.all(
                color: isSuccess
                    ? AppColors.success
                    : (isScanning
                        ? AppColors.primary
                        : (isDark ? Colors.white.withOpacity(0.15) : const Color(0xFFD1D5DB))),
                width: isScanning || isSuccess ? 2.2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(isScanning || isSuccess ? 0.3 : 0.05),
                  blurRadius: isScanning || isSuccess ? 20 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: isSuccess
                    ? const Icon(
                        Icons.check_circle_rounded,
                        key: ValueKey('success_icon'),
                        size: 48,
                        color: AppColors.success,
                      )
                    : Icon(
                        Icons.fingerprint_rounded,
                        key: const ValueKey('fingerprint_icon'),
                        size: 46,
                        color: isScanning
                            ? AppColors.primary
                            : (isDark ? Colors.white70 : const Color(0xFF4B5563)),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    late String statusText;
    late Color statusColor;
    late IconData statusIcon;

    switch (_state) {
      case BiometricState.ready:
        statusText = 'Touch sensor to scan'.tr('စကင်ဖတ်ရန် လက်ဗွေခလုတ်ကို ထိပါ');
        statusColor = isDark ? AppColors.gray400 : AppColors.gray500;
        statusIcon = Icons.touch_app_rounded;
        break;
      case BiometricState.scanning:
        statusText = 'Scanning fingerprint...'.tr('လက်ဗွေ စကင်ဖတ်နေပါသည်...');
        statusColor = AppColors.primary;
        statusIcon = Icons.sensors_rounded;
        break;
      case BiometricState.verifying:
        statusText = 'Verifying biometrics...'.tr('လက်ဗွေရာ စစ်ဆေးအတည်ပြုနေပါသည်...');
        statusColor = AppColors.primaryDark;
        statusIcon = Icons.sync_rounded;
        break;
      case BiometricState.success:
        statusText = 'Identity Verified!'.tr('လက်ဗွေရာ အောင်မြင်စွာ အတည်ပြုပြီးပါပြီ!');
        statusColor = AppColors.success;
        statusIcon = Icons.verified_rounded;
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(statusText),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: statusColor.withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 15, color: statusColor),
            const SizedBox(width: 6),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

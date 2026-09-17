import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Himo Pay — Inter Typography System
/// Strictly based on Section 9 of the Design System specification.
class AppTextStyles {
  // ── Display: 32 / 40 / 700 ──
  static TextStyle get display => GoogleFonts.inter(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.6,
  );

  // ── H1: 28 / 36 / 700 ──
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  // ── H2: 24 / 32 / 700 ──
  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  // ── H3: 20 / 28 / 600 ──
  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  // ── Body Large: 18 / 28 / 400 ──
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Body: 16 / 24 / 400 ──
  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Body Small: 14 / 20 / 400 ──
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Label: 14 / 20 / 500 ──
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // ── Caption: 12 / 16 / 400 ──
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // ── Button Text: 14 / 20 / 600 ──
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textInverse,
    letterSpacing: 0.1,
  );

  // ── Amount Big: 32 / 40 / 900 ──
  static TextStyle get amountBig => GoogleFonts.inter(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.8,
  );

  // ── Backward Compatible / Semantic Helpers ──
  static TextStyle get subtitle => label;
  
  static TextStyle get bodyMuted => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get monoCode => GoogleFonts.spaceMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );
}

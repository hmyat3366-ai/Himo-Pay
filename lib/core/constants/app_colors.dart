import 'package:flutter/material.dart';

/// Himo Pay — Light & Dark Mode Semantic Color System
/// Brand Direction: Orange + Charcoal + White
class AppColors {
  // ── 1. Primary Brand Orange ──
  static const Color primary = Color(0xFFFF5E14); // Fintech Orange (Primary Brand Action)
  static const Color primaryDarkTheme = Color(0xFFFF6B26); // Accessible Orange for Dark Mode
  static const Color primaryHover = Color(0xFFE64E07);
  static const Color primaryPressed = Color(0xFFCC4204);
  static const Color primaryDeep = Color(0xFFB33600);
  
  // Soft Brand Accents
  static const Color primarySoft = Color(0xFFFFF1EB); // Light Mode warm peach tint
  static const Color primarySoftDark = Color(0xFF2A1A12); // Dark Mode warm charcoal tint
  static const Color primarySubtle = Color(0x24FF5E14); // 14% opacity Orange

  // Backward compatibility alias for existing code
  static const Color primaryGold = Color(0xFFFF5E14);
  static const Color primaryDark = Color(0xFFB33600);
  static const Color brandOrange = Color(0xFFFF5E14);
  static const Color brandOrangeDark = Color(0xFFFF6B26);

  // ── 2. Charcoal & Dark Palette ──
  static const Color charcoalDeep = Color(0xFF0D1117); // Dark Mode Main Background
  static const Color charcoalSurface = Color(0xFF161B22); // Dark Mode Cards
  static const Color charcoalElevated = Color(0xFF21262D); // Dark Mode Modals / Top sheets
  static const Color charcoalText = Color(0xFF161A22); // Light Mode Primary Text

  // ── 3. Light Mode Surfaces & Backgrounds ──
  static const Color backgroundLight = Color(0xFFF6F8FA); // Warm clean light neutral
  static const Color surfaceCardLight = Color(0xFFFFFFFF); // Pure White Cards
  static const Color surfaceSecondaryLight = Color(0xFFEEF1F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F8FA);

  // ── 4. Dark Mode Surfaces & Backgrounds ──
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color surfaceCardDark = Color(0xFF161B22);
  static const Color surfaceElevatedDark = Color(0xFF21262D);
  static const Color surfaceSecondaryDark = Color(0xFF1A1F26);

  // ── 5. Typography Hierarchy ──
  // Light Mode Text
  static const Color textPrimaryLight = Color(0xFF161A22); // Charcoal primary
  static const Color textSecondaryLight = Color(0xFF576071); // Neutral slate
  static const Color textTertiaryLight = Color(0xFF8C95A6); // Muted caption
  static const Color textDisabledLight = Color(0xFFB0B7C3);

  // Dark Mode Text
  static const Color textPrimaryDark = Color(0xFFF0F3F6); // Crisp Off-white
  static const Color textSecondaryDark = Color(0xFF8B949E); // Soft slate
  static const Color textTertiaryDark = Color(0xFF6E7681); // Muted caption
  static const Color textDisabledDark = Color(0xFF484F58);

  // General Text Aliases
  static const Color textPrimary = Color(0xFF161A22);
  static const Color textSecondary = Color(0xFF576071);
  static const Color textTertiary = Color(0xFF8C95A6);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ── 6. Borders & Dividers ──
  static const Color borderLight = Color(0xFFE2E6EC);
  static const Color borderSubtleLight = Color(0xFFECEEF2);
  static const Color borderDark = Color(0xFF272E38);
  static const Color borderSubtleDark = Color(0xFF1C2128);
  static const Color border = Color(0xFFE2E6EC);
  static const Color borderStrong = Color(0xFFC8CFD9);

  // ── 7. Financial Status Colors (Color + Icon + Text) ──
  // Success (Green)
  static const Color success = Color(0xFF10B981);
  static const Color successSoft = Color(0xFFE6F8F1);
  static const Color successSoftDark = Color(0xFF0C2B21);
  static const Color successBg = Color(0x1F10B981);

  // Warning / Pending (Amber)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color warningSoftDark = Color(0xFF2D2109);
  static const Color warningBg = Color(0x1FF59E0B);

  // Error / Failed (Red)
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFEE2E2);
  static const Color errorSoftDark = Color(0xFF2B1212);
  static const Color errorBg = Color(0x1FEF4444);

  // Info (Cobalt Blue)
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0xFFEFF6FF);
  static const Color infoSoftDark = Color(0xFF122038);
  static const Color infoBg = Color(0x1F3B82F6);

  // ── 8. Monochrome Base ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0A0A);
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F4F8);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // ── 9. Theme-Aware Token Resolvers ──
  static Color brandFor(bool isDark) => isDark ? primaryDarkTheme : primary;
  static Color brandSoftFor(bool isDark) => isDark ? primarySoftDark : primarySoft;
  static Color backgroundFor(bool isDark) => isDark ? backgroundDark : backgroundLight;
  static Color surfaceFor(bool isDark) => isDark ? surfaceCardDark : surfaceCardLight;
  static Color textPrimaryFor(bool isDark) => isDark ? textPrimaryDark : textPrimaryLight;
  static Color textSecondaryFor(bool isDark) => isDark ? textSecondaryDark : textSecondaryLight;
  static Color borderFor(bool isDark) => isDark ? borderDark : borderLight;
}

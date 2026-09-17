import 'package:flutter/material.dart';

/// Himo Pay — Navy Blue Border Radius System
/// Based on Section 9 of the 'Himo Pay Navy Blue Visual Rebrand' specification.
class AppRadius {
  static const double sm = 8.0; // Small controls (buttons, badges)
  static const double input = 10.0; // Input fields
  static const double md = 12.0;
  static const double card = 16.0; // Cards
  static const double modal = 20.0; // Large containers & bottom sheets
  static const double pill = 9999.0; // Pills & rounded tags
  static const double circular = 9999.0;

  static const BorderRadius smBorder = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius inputBorder = BorderRadius.all(Radius.circular(input));
  static const BorderRadius mdBorder = BorderRadius.all(Radius.circular(md));
  static const BorderRadius cardBorder = BorderRadius.all(Radius.circular(card));
  static const BorderRadius modalTop = BorderRadius.only(
    topLeft: Radius.circular(modal),
    topRight: Radius.circular(modal),
  );
  static const BorderRadius pillBorder = BorderRadius.all(Radius.circular(pill));
}

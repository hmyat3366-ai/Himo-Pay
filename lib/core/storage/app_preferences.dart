import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _keyLocale = 'app_locale';
  static const String _keyTheme = 'app_theme';
  static const String _keySound = 'app_sound_effects';
  static const String _keyAutoReceipt = 'app_auto_receipt';
  static const String _keyBalanceHidden = 'app_balance_hidden';
  static const String _keyIsLoggedIn = 'app_is_logged_in';
  static const String _keyActiveUserId = 'app_active_user_id';
  static const String _keyActivePhone = 'app_active_phone';
  static const String _keyActiveName = 'app_active_name';

  static late SharedPreferences _prefs;

  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final ValueNotifier<String> localeNotifier = ValueNotifier<String>('en');
  static final ValueNotifier<bool> soundEffectsNotifier = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> autoReceiptNotifier = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> balanceHiddenNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> activeUserIdNotifier = ValueNotifier<String?>(null);

  static bool get isDark => themeModeNotifier.value == ThemeMode.dark;
  static bool get isMyanmar => localeNotifier.value == 'my';
  static bool get isLoggedIn => isLoggedInNotifier.value;
  static String? get activeUserId => activeUserIdNotifier.value;
  static String? get activePhone {
    try {
      return _prefs.getString(_keyActivePhone);
    } catch (_) {
      return null;
    }
  }
  static String? get activeName {
    try {
      return _prefs.getString(_keyActiveName);
    } catch (_) {
      return null;
    }
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // 1. Restore Locale
    final savedLocale = _prefs.getString(_keyLocale) ?? 'en';
    localeNotifier.value = savedLocale;

    // 2. Restore Theme
    final savedTheme = _prefs.getString(_keyTheme) ?? 'light';
    themeModeNotifier.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

    // 3. Restore Sounds
    soundEffectsNotifier.value = _prefs.getBool(_keySound) ?? true;

    // 4. Restore Auto Receipt
    autoReceiptNotifier.value = _prefs.getBool(_keyAutoReceipt) ?? true;

    // 5. Restore Balance Hidden
    balanceHiddenNotifier.value = _prefs.getBool(_keyBalanceHidden) ?? false;

    // 6. Restore Logged In State & Active User
    isLoggedInNotifier.value = _prefs.getBool(_keyIsLoggedIn) ?? false;
    activeUserIdNotifier.value = _prefs.getString(_keyActiveUserId);
  }

  // ── Setters with Storage Persistence ──
  static Future<void> toggleTheme() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    themeModeNotifier.value = next;
    await _prefs.setString(_keyTheme, next == ThemeMode.dark ? 'dark' : 'light');
    triggerHaptic(HapticType.selection);
  }

  static Future<void> setTheme(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    await _prefs.setString(_keyTheme, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  static Future<void> toggleLocale() async {
    final next = isMyanmar ? 'en' : 'my';
    localeNotifier.value = next;
    await _prefs.setString(_keyLocale, next);
    triggerHaptic(HapticType.selection);
  }

  static Future<void> setLocale(String lang) async {
    final code = (lang == 'my' || lang == 'မြန်မာ') ? 'my' : 'en';
    localeNotifier.value = code;
    await _prefs.setString(_keyLocale, code);
  }

  static Future<void> toggleSoundEffects() async {
    final next = !soundEffectsNotifier.value;
    soundEffectsNotifier.value = next;
    await _prefs.setBool(_keySound, next);
    if (next) triggerHaptic(HapticType.light);
  }

  static Future<void> toggleAutoReceipt() async {
    final next = !autoReceiptNotifier.value;
    autoReceiptNotifier.value = next;
    await _prefs.setBool(_keyAutoReceipt, next);
    triggerHaptic(HapticType.selection);
  }

  static Future<void> toggleBalanceHidden() async {
    final next = !balanceHiddenNotifier.value;
    balanceHiddenNotifier.value = next;
    await _prefs.setBool(_keyBalanceHidden, next);
    triggerHaptic(HapticType.light);
  }

  static Future<void> setLoggedIn(bool val) async {
    isLoggedInNotifier.value = val;
    await _prefs.setBool(_keyIsLoggedIn, val);
  }

  static Future<void> setActiveUser(String userId, {String? phone, String? name}) async {
    activeUserIdNotifier.value = userId;
    await _prefs.setString(_keyActiveUserId, userId);
    if (phone != null) await _prefs.setString(_keyActivePhone, phone);
    if (name != null) await _prefs.setString(_keyActiveName, name);
  }

  static Future<void> clearSession() async {
    isLoggedInNotifier.value = false;
    activeUserIdNotifier.value = null;
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _prefs.remove(_keyActiveUserId);
    await _prefs.remove(_keyActivePhone);
    await _prefs.remove(_keyActiveName);
  }

  // ── Unified Haptic Feedback Service ──
  static void triggerHaptic([HapticType type = HapticType.light]) {
    if (!soundEffectsNotifier.value) return;

    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
  vibrate,
}

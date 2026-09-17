import 'package:flutter/foundation.dart';
import '../storage/app_preferences.dart';

class LocaleManager {
  static ValueNotifier<String> get currentLocale => AppPreferences.localeNotifier;

  static bool get isMyanmar => AppPreferences.isMyanmar;
  static String get languageBadge => isMyanmar ? 'မြန်မာ' : 'EN';
  static String get languageName => isMyanmar ? 'မြန်မာ' : 'English';

  static void toggle() {
    AppPreferences.toggleLocale();
  }

  static void setLocale(String lang) {
    AppPreferences.setLocale(lang);
  }
}


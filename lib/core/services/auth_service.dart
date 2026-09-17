import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase/supabase_config.dart';
import '../../core/storage/app_preferences.dart';

/// Authentication service wrapping Supabase phone OTP auth.
///
/// Flow:
///   1. sendOtp(phone)   → Supabase sends SMS OTP
///   2. verifyOtp(phone, token) → signs user in; returns [User]
///   3. signOut()        → signs user out, clears login state
class AuthService {
  AuthService._();

  static final _client = SupabaseConfig.client;

  // ─── Current Session / User ───────────────────────────────────────────────

  static User? get currentUser => _client.auth.currentUser;
  static Session? get currentSession => _client.auth.currentSession;
  static bool get isSignedIn => currentUser != null;

  // ─── Phone OTP ────────────────────────────────────────────────────────────

  /// Send OTP to [phone] (format: +95XXXXXXXXX or 09XXXXXXXX — we normalise).
  static Future<AuthResponse?> sendOtp(String phone) async {
    final normalised = _normalisePhone(phone);
    await _client.auth.signInWithOtp(phone: normalised);
    return null; // OTP sent; no response needed at this step
  }

  /// Verify OTP. Returns [AuthResponse] on success, throws on failure.
  static Future<AuthResponse> verifyOtp(String phone, String token) async {
    final normalised = _normalisePhone(phone);
    final response = await _client.auth.verifyOTP(
      phone: normalised,
      token: token,
      type: OtpType.sms,
    );
    if (response.user != null) {
      await AppPreferences.setLoggedIn(true);
      // Upsert profile row after first login
      await _upsertProfile(response.user!);
    }
    return response;
  }

  /// Sign out and clear local login state.
  static Future<void> signOut() async {
    await _client.auth.signOut();
    await AppPreferences.setLoggedIn(false);
  }

  // ─── Demo / Mock Login (no real OTP needed) ───────────────────────────────

  /// Used by "Quick Demo Login" button — logs in with anonymous session.
  static Future<void> signInAsDemo() async {
    await AppPreferences.setLoggedIn(true);
    // In production you could create an anon session here:
    // await _client.auth.signInAnonymously();
  }

  // ─── Profile Upsert ───────────────────────────────────────────────────────

  static Future<void> _upsertProfile(User user) async {
    try {
      final phone = user.phone ?? '';
      final himoId = 'HM${phone.replaceAll('+', '').substring(phone.length > 4 ? phone.length - 4 : 0)}';
      await _client.from('profiles').upsert({
        'id': user.id,
        'himo_id': himoId,
        'name': 'Himo User',
        'phone': phone,
      }, onConflict: 'id');
    } catch (_) {
      // Non-fatal: profile may already exist
    }
  }

  // ─── Phone Normalisation ──────────────────────────────────────────────────

  /// Converts `09XXXXXXXX` or `9XXXXXXXX` to E.164 `+959XXXXXXXX`.
  static String _normalisePhone(String raw) {
    var p = raw.trim().replaceAll(' ', '').replaceAll('-', '');
    if (p.startsWith('+')) return p;
    if (p.startsWith('09')) return '+95${p.substring(1)}';
    if (p.startsWith('9')) return '+95$p';
    return '+95$p';
  }
}

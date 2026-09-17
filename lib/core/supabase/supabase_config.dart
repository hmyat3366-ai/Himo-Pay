// Supabase configuration for Himo Pay
// Project: himo-pay | Region: ap-southeast-1
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String projectUrl = 'https://rtqtbiptdiqyqryomeyw.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0cXRiaXB0ZGlxeXFyeW9tZXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkwMDk2NTgsImV4cCI6MjEwNDU4NTY1OH0.mEgNi5Ea70uBu63GasuI-VXjPZVMoIg9PbtN86bt1EA';

  /// Shorthand getter for the Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}

import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

/// Centralized Supabase client accessor.
/// Role is fetched from user_metadata in Supabase Auth.
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static bool get isLoggedIn => currentUser != null;

  static String get userEmail => currentUser?.email ?? 'Guest';

  /// Fetch the user's role from user_metadata.
  static String fetchUserRole() {
    final user = currentUser;
    if (user == null) {
      return AppConstants.roleUser;
    }

    // Cek di user_metadata dulu (bisa diubah user)
    String? role = user.userMetadata?['role'] as String?;

    // Jika tidak ada, cek di app_metadata (lebih aman, hanya admin Supabase yang bisa ubah)
    role ??= user.appMetadata['role'] as String?;

    // Default ke 'user' jika tidak ada
    role ??= AppConstants.roleUser;

    return role;
  }

  /// Refresh user session to get latest metadata
  static Future<void> refreshSession() async {
    try {
      await client.auth.refreshSession();
    } catch (_) {}
  }
}


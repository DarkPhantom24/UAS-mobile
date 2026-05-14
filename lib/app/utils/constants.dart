/// Application constants
/// Centralized static constants for the entire application
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================
  // SUPABASE CONFIGURATION
  // ============================================

  static const String supabaseUrl = 'https://hbdvrcexdvhucqbvfeqo.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhiZHZyY2V4ZHZodWNxYnZmZXFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3MTI2MjksImV4cCI6MjA5NDI4ODYyOX0.M5nW2OHF_aXuGhi6Q405ddz5ZZ5P2ciMbh5iaw_DmKQ';

  // ============================================
  // TABLE NAMES
  // ============================================

  static const String moviesTable = 'movies';
  static const String profilesTable = 'profiles';

  // ============================================
  // USER ROLES
  // ============================================

  static const String roleAdmin = 'admin';
  static const String roleUser = 'user';

  // ============================================
  // ROUTES
  // ============================================

  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeAdminForm = '/admin-form';
  static const String routeMovieDetail = '/movie-detail';

  // ============================================
  // APP INFO
  // ============================================

  static const String appName = 'CineVault';
  static const String appVersion = '1.0.0';

  // ============================================
  // VALIDATION
  // ============================================

  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
}

import 'package:get/get.dart';
import '../services/supabase_service.dart';
import 'auth_controller.dart';
import 'loved_controller.dart';
import 'movie_controller.dart';

/// Controller for Profile View
/// Handles user profile information and statistics
class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final LovedController _lovedController = Get.find<LovedController>();
  final MovieController _movieController = Get.find<MovieController>();

  /// Get user email
  String get userEmail => _authController.userEmail.value;

  /// Check if user is admin
  bool get isAdmin => _authController.isAdmin.value;

  /// Get user role display name
  String get roleDisplayName => isAdmin ? 'Admin' : 'User';

  /// Get user initials (for avatar)
  String get userInitials {
    if (userEmail.isEmpty) return 'U';
    final parts = userEmail.split('@');
    if (parts.isEmpty) return 'U';
    final name = parts[0];
    if (name.isEmpty) return 'U';
    return name[0].toUpperCase();
  }

  /// Get watchlist count
  int get watchlistCount => _lovedController.watchlist.length;

  /// Get total movies count
  int get totalMoviesCount => _movieController.movies.length;

  /// Get user statistics
  Map<String, dynamic> get userStats {
    return {
      'watchlist': watchlistCount,
      'totalMovies': totalMoviesCount,
      'favoriteGenre': _getFavoriteGenre(),
      'averageRating': _getAverageWatchlistRating(),
    };
  }

  /// Get favorite genre (most common in watchlist)
  String _getFavoriteGenre() {
    if (_lovedController.watchlist.isEmpty) return 'None';

    final genreCounts = <String, int>{};
    for (var movie in _lovedController.watchlist) {
      genreCounts[movie.kategori] = (genreCounts[movie.kategori] ?? 0) + 1;
    }

    if (genreCounts.isEmpty) return 'None';

    var maxCount = 0;
    var favoriteGenre = 'None';
    genreCounts.forEach((genre, count) {
      if (count > maxCount) {
        maxCount = count;
        favoriteGenre = genre;
      }
    });

    return favoriteGenre;
  }

  /// Get average rating of watchlist movies
  double _getAverageWatchlistRating() {
    if (_lovedController.watchlist.isEmpty) return 0.0;

    final total = _lovedController.watchlist.fold<double>(
      0.0,
      (sum, movie) => sum + movie.skorRating,
    );

    return total / _lovedController.watchlist.length;
  }

  /// Logout
  Future<void> logout() async {
    await _authController.logout();
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    // Refresh auth data if needed
    _authController.onInit();
  }

  /// Get account creation date (if available)
  String get accountCreatedDate {
    final user = SupabaseService.currentUser;
    if (user == null) return 'Unknown';

    final createdAt = user.createdAt;
    if (createdAt.isEmpty) return 'Unknown';

    try {
      final date = DateTime.parse(createdAt);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get last sign in date
  String get lastSignInDate {
    final user = SupabaseService.currentUser;
    if (user == null) return 'Unknown';

    final lastSignIn = user.lastSignInAt;
    if (lastSignIn == null || lastSignIn.isEmpty) return 'Unknown';

    try {
      final date = DateTime.parse(lastSignIn);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movie_model.dart';

/// Controller for Loved/Watchlist View
/// Handles favorite movies management (moved from MovieController)
class LovedController extends GetxController {
  final watchlist = <MovieModel>[].obs;

  /// Toggle movie in watchlist
  void toggleWatchlist(MovieModel movie) {
    final exists = watchlist.any((m) => m.id == movie.id);
    if (exists) {
      watchlist.removeWhere((m) => m.id == movie.id);
      Get.snackbar(
        'Watchlist',
        'Removed from watchlist',
        backgroundColor: Colors.white10,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } else {
      watchlist.add(movie);
      Get.snackbar(
        'Watchlist',
        'Added to watchlist',
        backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  /// Check if movie is in watchlist
  bool isInWatchlist(String? id) {
    return watchlist.any((m) => m.id == id);
  }

  /// Remove from watchlist
  void removeFromWatchlist(MovieModel movie) {
    if (isInWatchlist(movie.id)) {
      toggleWatchlist(movie);
    }
  }

  /// Clear all watchlist
  void clearWatchlist() {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Watchlist'),
        content: const Text(
          'Are you sure you want to remove all movies from your watchlist?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              watchlist.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All movies removed from watchlist',
                backgroundColor: Colors.white10,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Check if watchlist is empty
  bool get isEmpty => watchlist.isEmpty;

  /// Get watchlist count
  int get count => watchlist.length;

  /// Get watchlist sorted by rating
  List<MovieModel> get sortedByRating {
    final sorted = List<MovieModel>.from(watchlist)
      ..sort((a, b) => b.skorRating.compareTo(a.skorRating));
    return sorted;
  }

  /// Get watchlist sorted by title
  List<MovieModel> get sortedByTitle {
    final sorted = List<MovieModel>.from(watchlist)
      ..sort((a, b) => a.judul.toLowerCase().compareTo(b.judul.toLowerCase()));
    return sorted;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../services/movie_provider.dart';

/// Handles all movie CRUD operations, search, sort, and watchlist.
class MovieController extends GetxController {
  final MovieProvider _provider = Get.find<MovieProvider>();

  final movies = <MovieModel>[].obs;
  final filteredMovies = <MovieModel>[].obs;
  final featuredMovies = <MovieModel>[].obs;
  final watchlist = <MovieModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final currentSortMode = 'default'.obs;

  // Hero carousel
  final currentCarouselIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
    // Debounced search
    debounce(searchQuery, (_) => _applyFilters(),
        time: const Duration(milliseconds: 300));
  }

  /// Fetch all movies from the API
  Future<void> fetchMovies() async {
    try {
      isLoading.value = true;
      final response = await _provider.getMovies();

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        final list = data.map((json) => MovieModel.fromJson(json)).toList();
        movies.assignAll(list);
        _applyFilters();
        _updateFeatured();
      } else {
        _showError('Failed to load movies (${response.statusCode})');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new movie (Admin only)
  Future<bool> createMovie(MovieModel movie) async {
    try {
      final response = await _provider.createMovie(movie.toJson());
      if (response.statusCode == 201) {
        await fetchMovies();
        Get.snackbar('Success', 'Movie added successfully!',
            backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return true;
      } else {
        _showError('Failed to create movie');
        return false;
      }
    } catch (e) {
      _showError('Error creating movie: $e');
      return false;
    }
  }

  /// Update an existing movie (Admin only)
  Future<bool> updateMovie(String id, MovieModel movie) async {
    try {
      final response = await _provider.updateMovie(id, movie.toJson());
      if (response.statusCode == 200) {
        await fetchMovies();
        Get.snackbar('Success', 'Movie updated successfully!',
            backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return true;
      } else {
        _showError('Failed to update movie');
        return false;
      }
    } catch (e) {
      _showError('Error updating movie: $e');
      return false;
    }
  }

  /// Delete a movie (Admin only)
  Future<bool> deleteMovie(String id) async {
    try {
      final response = await _provider.deleteMovie(id);
      if (response.statusCode == 200) {
        await fetchMovies();
        Get.snackbar('Deleted', 'Movie removed.',
            backgroundColor: Colors.redAccent.withValues(alpha: 0.3),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        return true;
      } else {
        _showError('Failed to delete movie');
        return false;
      }
    } catch (e) {
      _showError('Error deleting movie: $e');
      return false;
    }
  }

  /// Toggle watchlist
  void toggleWatchlist(MovieModel movie) {
    final exists = watchlist.any((m) => m.id == movie.id);
    if (exists) {
      watchlist.removeWhere((m) => m.id == movie.id);
      Get.snackbar('Watchlist', 'Removed from watchlist',
          backgroundColor: Colors.white10,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1));
    } else {
      watchlist.add(movie);
      Get.snackbar('Watchlist', 'Added to watchlist',
          backgroundColor: const Color(0xFF00E5FF).withValues(alpha: 0.2),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1));
    }
  }

  bool isInWatchlist(String? id) {
    return watchlist.any((m) => m.id == id);
  }

  /// Search
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Sort
  void sortMovies(String mode) {
    currentSortMode.value = mode;
    _applyFilters();
    Get.back(); // Close the bottom sheet
  }

  void _applyFilters() {
    List<MovieModel> result = List.from(movies);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((m) =>
              m.judul
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              m.kategori
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Sort
    switch (currentSortMode.value) {
      case 'az':
        result.sort(
            (a, b) => a.judul.toLowerCase().compareTo(b.judul.toLowerCase()));
        break;
      case 'za':
        result.sort(
            (a, b) => b.judul.toLowerCase().compareTo(a.judul.toLowerCase()));
        break;
      case 'newest':
        result.sort((a, b) => b.tanggalRilis.compareTo(a.tanggalRilis));
        break;
      case 'oldest':
        result.sort((a, b) => a.tanggalRilis.compareTo(b.tanggalRilis));
        break;
      case 'rating':
        result.sort((a, b) => b.skorRating.compareTo(a.skorRating));
        break;
      default:
        break;
    }

    filteredMovies.assignAll(result);
  }

  void _updateFeatured() {
    // Top 5 highest rated movies for the hero carousel
    final sorted = List<MovieModel>.from(movies)
      ..sort((a, b) => b.skorRating.compareTo(a.skorRating));
    featuredMovies.assignAll(sorted.take(5));
  }

  /// Get movies by category
  List<MovieModel> getByCategory(String category) {
    return movies.where((m) => m.kategori == category).toList();
  }

  /// Get unique categories
  List<String> get categories {
    return movies.map((m) => m.kategori).toSet().toList();
  }

  /// Get trending (by rating > 70)
  List<MovieModel> get trendingMovies {
    return movies.where((m) => m.skorRating >= 70).toList();
  }

  /// Get new releases (sorted by tanggal_rilis descending, top 10)
  List<MovieModel> get newReleases {
    final sorted = List<MovieModel>.from(movies)
      ..sort((a, b) => b.tanggalRilis.compareTo(a.tanggalRilis));
    return sorted.take(10).toList();
  }

  void _showError(String message) {
    Get.snackbar('Error', message,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.3),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }
}

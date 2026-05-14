import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movie_model.dart';
import 'movie_controller.dart';

/// Controller for Search View
/// Handles movie search, filtering, and sorting (moved from MovieController)
class SearchController extends GetxController {
  final MovieController _movieController = Get.find<MovieController>();
  final TextEditingController searchTextController = TextEditingController();

  final searchQuery = ''.obs;
  final filteredMovies = <MovieModel>[].obs;
  final currentSortMode = 'default'.obs;
  final recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Debounced search (moved from MovieController)
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
    // Update filtered when movies change
    ever(_movieController.movies, (_) => _applyFilters());
    _applyFilters();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  /// Apply search and sort filters (moved from MovieController)
  void _applyFilters() {
    List<MovieModel> result = List.from(_movieController.movies);

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where(
            (m) =>
                m.judul.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                m.kategori.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
          )
          .toList();
    }

    // Sort
    switch (currentSortMode.value) {
      case 'az':
        result.sort(
          (a, b) => a.judul.toLowerCase().compareTo(b.judul.toLowerCase()),
        );
        break;
      case 'za':
        result.sort(
          (a, b) => b.judul.toLowerCase().compareTo(a.judul.toLowerCase()),
        );
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

  /// Update search query (moved from MovieController)
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  /// Sort movies (moved from MovieController)
  void sortMovies(String mode) {
    currentSortMode.value = mode;
    _applyFilters();
    Get.back(); // Close the bottom sheet
  }

  /// Submit search (add to recent searches)
  void submitSearch() {
    if (searchQuery.value.isNotEmpty) {
      if (!recentSearches.contains(searchQuery.value)) {
        recentSearches.insert(0, searchQuery.value);
        if (recentSearches.length > 10) {
          recentSearches.removeLast();
        }
      }
    }
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchTextController.clear();
  }

  /// Select recent search
  void selectRecentSearch(String query) {
    searchQuery.value = query;
    searchTextController.text = query;
  }

  /// Remove recent search
  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  /// Clear all recent searches
  void clearRecentSearches() {
    recentSearches.clear();
  }

  /// Get unique categories
  List<String> get categories {
    return _movieController.movies.map((m) => m.kategori).toSet().toList();
  }

  /// Get search result count
  int get resultCount => filteredMovies.length;

  /// Check if has results
  bool get hasResults => filteredMovies.isNotEmpty;

  /// Check if query is empty
  bool get isQueryEmpty => searchQuery.value.isEmpty;
}

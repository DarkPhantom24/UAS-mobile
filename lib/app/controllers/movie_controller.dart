import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../services/movie_provider.dart';

/// Handles movie CRUD operations only
class MovieController extends GetxController {
  final MovieProvider _provider = Get.find<MovieProvider>();

  final movies = <MovieModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
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
        Get.snackbar(
          'Success',
          'Movie added successfully!',
          backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
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
        Get.snackbar(
          'Success',
          'Movie updated successfully!',
          backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
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
        Get.snackbar(
          'Deleted',
          'Movie removed.',
          backgroundColor: Colors.redAccent.withOpacity(0.3),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
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

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent.withOpacity(0.3),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}

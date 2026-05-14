import 'package:get/get.dart';
import '../models/movie_model.dart';
import 'movie_controller.dart';

/// Controller for Home View
/// Handles featured movies, categories, trending, and carousel
class HomeController extends GetxController {
  final MovieController _movieController = Get.find<MovieController>();

  final currentCarouselIndex = 0.obs;
  final featuredMovies = <MovieModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Update featured when movies change
    ever(_movieController.movies, (_) => _updateFeatured());
    _updateFeatured();
  }

  /// Update featured movies (top 5 highest rated)
  void _updateFeatured() {
    final sorted = List<MovieModel>.from(_movieController.movies)
      ..sort((a, b) => b.skorRating.compareTo(a.skorRating));
    featuredMovies.assignAll(sorted.take(5));
  }

  /// Get trending movies (rating > 70)
  List<MovieModel> get trendingMovies {
    return _movieController.movies.where((m) => m.skorRating >= 70).toList();
  }

  /// Get new releases (sorted by date, top 10)
  List<MovieModel> get newReleases {
    final sorted = List<MovieModel>.from(_movieController.movies)
      ..sort((a, b) => b.tanggalRilis.compareTo(a.tanggalRilis));
    return sorted.take(10).toList();
  }

  /// Get movies by category
  List<MovieModel> getByCategory(String category) {
    return _movieController.movies
        .where((m) => m.kategori == category)
        .toList();
  }

  /// Get unique categories
  List<String> get categories {
    return _movieController.movies.map((m) => m.kategori).toSet().toList();
  }

  /// Update carousel index
  void updateCarouselIndex(int index) {
    currentCarouselIndex.value = index;
  }

  /// Check if loading
  bool get isLoading => _movieController.isLoading.value;

  /// Get all movies
  List<MovieModel> get allMovies => _movieController.movies;
}

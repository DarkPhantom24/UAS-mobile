import 'package:get/get.dart';

/// GetConnect provider for all movie API interactions.
/// Base URL points to the MockAPI endpoint.
class MovieProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://68ff8dfbe02b16d1753e765d.mockapi.io';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  /// GET all movies
  Future<Response> getMovies() => get('/film');

  /// GET a single movie by ID
  Future<Response> getMovie(String id) => get('/film/$id');

  /// POST a new movie
  Future<Response> createMovie(Map<String, dynamic> body) =>
      post('/film', body);

  /// PUT (update) an existing movie
  Future<Response> updateMovie(String id, Map<String, dynamic> body) =>
      put('/film/$id', body);

  /// DELETE a movie
  Future<Response> deleteMovie(String id) => delete('/film/$id');
}

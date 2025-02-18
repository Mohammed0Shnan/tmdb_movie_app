abstract class MovieCacheStorage {
  Future<Map<String, dynamic>?> getMoviesCache({required String category});

  Future<void> saveMoviesCache( Map<String, dynamic> movies, {required String category});
}

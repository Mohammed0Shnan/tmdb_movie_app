import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/interfaces/movie_cache_storage.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getMoviesCache(String category ,int page); // Fetch movies by category
  Future<void> cacheMovies(MoviesModel movies, String category ,int page); // Cache movies by category
}
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final MovieCacheStorage movieStorage;

  MovieLocalDataSourceImpl({
    required this.movieStorage,

  });

  @override
  Future<void> cacheMovies(MoviesModel movies, String category, int page) async {
    try {
      final Map<String,dynamic> moviesMap = {
        for (var movie in movies.items ?? []) movie.id.toString(): movie.toJson(),
      };
      await movieStorage.saveMoviesCache(moviesMap, category: '$category $page');
    } catch (e) {
      throw CacheException('Error caching movies in $category for page $page: ${e.toString()}');
    }
  }



  @override
  Future<List<MovieModel>> getMoviesCache(String category, int page) async {
    try {
      final moviesList = await movieStorage.getMoviesCache(category: '$category $page',);
        return moviesList!.entries
            .map((entry) => MovieModel.fromJson(Map<String, dynamic>.from(entry.value)))
            .toList();

    } catch (e) {
      throw CacheException('Error fetching cached movies for $category on page $page: ${e.toString()}');
    }
  }

}

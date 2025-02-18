import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../interfaces/movie_cache_storage.dart';

class HiveMovieCacheStorage implements MovieCacheStorage {
  final Box<Map<String, dynamic>> moviesBox;

  HiveMovieCacheStorage({required this.moviesBox});

  @override
  Future<Map<String, dynamic>> getMoviesCache({required String category}) async {
    try {
      print('Fetching cache for category: $category');

       moviesBox.get(category);

      return {}; // Return empty if no valid cache found
    } catch (e) {
      print('Cache retrieval error: $e');
      throw CacheException('Error retrieving movies cache for $category');
    }
  }


  @override
  Future<void> saveMoviesCache(Map<String, dynamic> movies, {required String category})async {
    try {
      await moviesBox.put(category, movies);
    } catch (e) {
      throw CacheException(
          'Error saving movies cache for $category: ${e.toString()}');
    }
  }


}

import 'package:hive/hive.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie_detail.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/interfaces/movie_favorites_storage.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoriteMovieLocalDataSource {
  Future<void> toggleFavorite(Movie movie);
  Future<List<Movie>> getFavoriteMovies();
}
class FavoriteMovieLocalDataSourceImpl implements FavoriteMovieLocalDataSource {

  final MovieFavoritesStorage favoritesStorage;

  FavoriteMovieLocalDataSourceImpl({  required this.favoritesStorage,});

  @override
  Future<void> toggleFavorite(Movie movie) async {
    try {
      final favorites = await favoritesStorage.getFavorites() ?? {};
      favorites[movie.id] = movie;
      await favoritesStorage.saveFavorites(favorites);
    } catch (e) {
      throw CacheException('Error saving favorite movie: ${e.toString()}');
    }
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    try {
      final favoritesList = await favoritesStorage.getFavorites();
      if (favoritesList != null) {
        return favoritesList.entries
            .map((entry) => MovieModel.fromJson(Map<String, dynamic>.from(entry.value)))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Error fetching favorite movies: ${e.toString()}');
    }
  }
}

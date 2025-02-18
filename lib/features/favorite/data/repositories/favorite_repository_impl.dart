import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorate_locale_data_source.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteMovieLocalDataSource localDataSource;

  FavoriteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> toggleFavorite(Movie movie) async {
    try {
      await localDataSource.toggleFavorite(movie);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure("Cache Error"));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      final movies = await localDataSource.getFavoriteMovies();
      return Right(movies);
    } catch (e) {
      return Left(CacheFailure("Cache Error"));
    }
  }
}

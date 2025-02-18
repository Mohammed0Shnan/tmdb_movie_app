import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> toggleFavorite(Movie movie);
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
}

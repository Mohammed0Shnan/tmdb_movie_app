
import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../movies/domain/entities/movie.dart';

class GetFavoriteMovies implements UseCase<List<Movie>, NoParams> {
  final FavoriteRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) {
    return repository.getFavoriteMovies();
  }
}


import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies implements UseCase<MoviesEntity, Params> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, MoviesEntity>> call(Params params) {
    return repository.getPopularMovies( (params as PageParams).page);
  }
}

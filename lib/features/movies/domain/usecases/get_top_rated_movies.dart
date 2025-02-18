import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMovies implements UseCase<MoviesEntity, Params> {
  final MovieRepository repository;

  GetTopRatedMovies(this.repository);

  @override
  Future<Either<Failure, MoviesEntity>> call(Params params) {
    return repository.getTopRatedMovies( (params as PageParams).page);
  }
}


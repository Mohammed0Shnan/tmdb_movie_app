import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie_video.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/movie_repository.dart';

class GetMovieVideos implements UseCase<List<MovieVideo>, MovieParams>{
  final MovieRepository repository;

  GetMovieVideos(this.repository);

  @override
  Future<Either<Failure, List<MovieVideo>>> call(MovieParams params) {
    return repository.getMovieVideos(params.id);
  }


}

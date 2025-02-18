import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../entities/movie_video.dart';

  abstract class MovieRepository {
    Future<Either<Failure, MoviesEntity>> getPopularMovies(int page);
    Future<Either<Failure, MoviesEntity>> getTopRatedMovies(int page);
    Future<Either<Failure, MoviesEntity>> getNowPlayingMovies(int page);

    Future<Either<Failure, MovieDetail>> getMovieDetails(int id);
    Future<Either<Failure, List<MovieVideo>>> getMovieVideos(int movieId);
  }
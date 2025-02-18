import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/movies/data/models/video_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
final MovieRemoteDataSource remoteDataSource;
final MovieLocalDataSource localDataSource;
final NetworkInfo networkInfo;

MovieRepositoryImpl({
  required this.remoteDataSource,
  required this.localDataSource,
  required this.networkInfo,
});

@override
Future<Either<Failure, MoviesModel>> getPopularMovies(int page) async {
  return await _getMovies(() => remoteDataSource.getPopularMovies(page),"popular",page);
}

@override
Future<Either<Failure,MoviesModel>> getTopRatedMovies(int page) async {
  return await _getMovies(() => remoteDataSource.getTopRatedMovies(page),"topRated",page);
}

@override
Future<Either<Failure, MoviesModel>> getNowPlayingMovies(int page) async {
  return await _getMovies(() => remoteDataSource.getNowPlayingMovies(page),"nowPlaying" , page);
}

@override
Future<Either<Failure, MovieDetail>> getMovieDetails(int id) async {
  try {
    if (await networkInfo.isConnected) {
      final movieDetail = await remoteDataSource.getMovieDetails(id);
      return Right(movieDetail);
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}


  Future<Either<Failure, MoviesModel>> _getMovies(
      Future<MoviesModel> Function() getMovies,
      String category,
      int page
      ) async {
  bool isConnected  = await networkInfo.isConnected;
    if (isConnected) {
      try {
        MoviesModel movies = await getMovies();
        await localDataSource.cacheMovies(movies, category, page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        print('++++++111111++++++');
        final localMovies = await localDataSource.getMoviesCache(category,page);
        print('++++++222222++++++');
        if (localMovies.isNotEmpty) {
          return Right(MoviesModel(
            items: localMovies,
            totalResults: localMovies.length,
            totalPages: 1, // Adjust accordingly
          ));
        } else {
          return Left(CacheFailure('No cached movies available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<MovieVideoModel>>> getMovieVideos(int movieId) async {
    try {
      final videos = await remoteDataSource.getMovieVideos(movieId);
      return Right(videos);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

}
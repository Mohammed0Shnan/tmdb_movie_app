import 'package:dio/dio.dart';
import '../../../../core/const/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';

abstract class MovieRemoteDataSource {
  Future<MoviesModel> getPopularMovies(int page);
  Future<MoviesModel> getTopRatedMovies(int page);
  Future<MoviesModel> getNowPlayingMovies(int page);
  Future<MovieDetailModel> getMovieDetails(int id);
  Future<List<MovieVideoModel>> getMovieVideos(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<MoviesModel> getPopularMovies(int page) async {
    try {
      print('=============> Popular <=================');
      final response = await client.get(
        ApiConstants.popularMovies,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
          'page': page.toString(),
        },
      );

      if (response != null && response['results'] != null) {
        return MoviesModel.fromMap({
          'results': response['results'],
          'total_results': response['total_results'],
          'total_pages': response['total_pages'],
        });
      } else {
        throw ServerException('Failed to fetch popular movies');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to fetch popular movies',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MoviesModel> getTopRatedMovies(int page) async {
    try {
      print('=============> Top Rating <=================');
      final response = await client.get(
        ApiConstants.topRatedMovies,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
          'page': page.toString(),
        },
      );

      if (response != null && response['results'] != null) {
        return MoviesModel.fromMap({
          'results': response['results'],
          'total_results': response['total_results'],
          'total_pages': response['total_pages'],
        });
      } else {
        throw ServerException('Failed to fetch popular movies');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to fetch popular movies',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MoviesModel> getNowPlayingMovies(int page) async {
    try {
      print('=============> Now Playing <=================');
      final response = await client.get(
        ApiConstants.nowPlayingMovies,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
          'page': page.toString(),
        },
      );

      if (response != null && response['results'] != null) {
        return MoviesModel.fromMap({
          'results': response['results'],
          'total_results': response['total_results'],
          'total_pages': response['total_pages'],
        });
      } else {
        throw ServerException('Failed to fetch popular movies');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to fetch popular movies',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MovieDetailModel> getMovieDetails(int id) async {
    try {
      final response = await client.get(
        '${ApiConstants.baseUrl}/movie/$id',
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
          'append_to_response': 'videos,credits',
        },
      );

      if (response != null) {
        return MovieDetailModel.fromJson(response);
      } else {
        throw ServerException('Failed to fetch movie details');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to fetch movie details',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }


  @override
  Future<List<MovieVideoModel>> getMovieVideos(int movieId) async {
    try {
      final response = await client.get(
        '${ApiConstants.movieBaseUrl}/$movieId/videos',
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
        },
      );

      if (response != null && response['results'] != null) {
        return (response['results'] as List)
            .map((video) => MovieVideoModel.fromJson(video))
            .toList();
      } else {
        throw ServerException('Failed to fetch movie videos');
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to fetch movie videos',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/core/errors/exceptions.dart';
import 'package:tmdb_movie_app/core/errors/failures.dart';
import 'package:tmdb_movie_app/core/network/network.dart';
import 'package:tmdb_movie_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:tmdb_movie_app/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:tmdb_movie_app/features/movies/data/models/movie_model.dart';
import 'package:tmdb_movie_app/features/movies/domain/repositories/movie_repository.dart'; // Import the repository
import '../../../../test_utilities/mock_data.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}
class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MovieRepository mockMovieRepository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockMovieRepository = MockMovieRepository();
  });

  group('getPopularMovies', () {
    const page = 1;

    final movieList = [ MovieModel(
      id: 1,
      title: 'Movie 1',
      overview: 'Overview of Movie 1',
      posterPath: 'poster1.jpg',
      backdropPath: 'backdrop1.jpg',
      voteAverage: 8.0,
      releaseDate: '2022-01-01',
      genreIds: [28, 35],
      adult: false,
      originalLanguage: 'en',
      originalTitle: 'Original Movie 1',
      popularity: 10.0,
      video: false,
    ),];
    final moviesModel = mockMoviesModel();
    test('should return remote data when internet is available', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPopularMovies(page)).thenAnswer((_) async => moviesModel);
      when(() => mockMovieRepository.getPopularMovies(page)).thenAnswer((_) async => Right(moviesModel));
      final result = await mockMovieRepository.getPopularMovies(page);
      expect(result.isRight(), true);
      result.fold(
            (failure) => null,
            (movies) => expect(movies.items?.length, 1),
      );
      verifyNever(() => mockRemoteDataSource.getPopularMovies(page));
      verifyNever(() => mockLocalDataSource.getMoviesCache('key', 1));
    });

    test('should return CacheFailure when no internet connection and no cached data', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getMoviesCache('key', 1)).thenThrow(CacheException('No cache'));
      when(() => mockMovieRepository.getPopularMovies(page)).thenAnswer((_) async => Left(CacheFailure('No cache')));
      final result = await mockMovieRepository.getPopularMovies(page);
      expect(result.isLeft(), true);
      result.fold(
            (failure) => expect(failure, isA<CacheFailure>()),
            (movies) => null,
      );
      verifyNever(() => mockRemoteDataSource.getPopularMovies(1));
      verifyNever(() => mockLocalDataSource.getMoviesCache('key', 1));
    });

    test('should return remote data when internet is available but cache fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getPopularMovies(page)).thenAnswer((_) async => moviesModel);
      when(() => mockLocalDataSource.getMoviesCache('key', 1)).thenThrow(CacheException('Cache Error'));
      when(() => mockMovieRepository.getPopularMovies(page)).thenAnswer((_) async => Right(moviesModel));

      // Act
      final result = await mockMovieRepository.getPopularMovies(page);
      expect(result.isRight(), true);
      result.fold(
            (failure) => null,
            (movies) => expect(movies.items?.length, 1),
      );
      verifyNever(() => mockRemoteDataSource.getPopularMovies(page));
      verifyNever(() => mockLocalDataSource.getMoviesCache('key', 1));
    });

    test('should return CacheFailure when no internet connection and there is cached data', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getMoviesCache('key', 1))
          .thenAnswer((_) async => Future.value(
        movieList ,
      ));      when(() => mockMovieRepository.getPopularMovies(page)).thenAnswer((_) async => Right(moviesModel));
      final result = await mockMovieRepository.getPopularMovies(page);

      // Assert
      expect(result.isRight(), true);
      result.fold(
            (failure) => null,
            (movies) => expect(movies.items?.length, 1),
      );
      verifyNever(() => mockRemoteDataSource.getPopularMovies(1));
      verifyNever(() => mockLocalDataSource.getMoviesCache('key', 1));
    });
  });
}

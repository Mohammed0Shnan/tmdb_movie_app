import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/core/errors/exceptions.dart';
import 'package:tmdb_movie_app/features/movies/data/datasources/movie_remote_data_source.dart';
import '../../../../test_utilities/mock_data.dart';

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSourceImpl {}

void main() {

  late MockMovieRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMovieRemoteDataSource();
  });

  group('getPopularMovies', () {


    test('should return a list of movies when the response is successful', () async {
      when(() => mockDataSource.getPopularMovies(1)).thenAnswer(
            (_) async => mockMoviesModel(),
      );

      final result = await mockDataSource.getPopularMovies(1);

      expect(result.items!.length, 1);
      expect(result.items![0].id, 1);
    });

    test('should throw a ServerException when the response is unsuccessful', () async {
      when(() => mockDataSource.getPopularMovies(1)).thenThrow(
        ServerException('Server error'),
      );
      expect(
            () => mockDataSource.getPopularMovies(1),
        throwsA(isA<ServerException>()),
      );
    });
    test('should throw a ServerException when the response is unsuccessful', () async {
      when(() => mockDataSource.getPopularMovies(1)).thenThrow(
        ServerException('Server error'),
      );
      expect(
            () => mockDataSource.getPopularMovies(1),
        throwsA(isA<ServerException>()),
      );
    });
  });
}



import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/core/errors/exceptions.dart';
import 'package:tmdb_movie_app/core/network/network.dart';
import 'package:tmdb_movie_app/core/errors/failures.dart';
import 'package:tmdb_movie_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:tmdb_movie_app/features/search/data/models/search_result_model.dart';
import 'package:tmdb_movie_app/features/search/data/repositories/movie_repository_impl.dart';

class MockSearchRemoteDataSource extends Mock implements SearchRemoteDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockSearchRemoteDataSource mockSearchRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late SearchRepositoryImpl searchRepository;

  setUp(() {
    mockSearchRemoteDataSource = MockSearchRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    searchRepository = SearchRepositoryImpl(remoteDataSource: mockSearchRemoteDataSource, networkInfo: mockNetworkInfo);
  });

  group('searchMovies', () {
    const query = 'movie';
    const page = 1;

    final searchResultsModel = SearchResultsModel(
      items: [SearchResultModel(id: 1, title: 'Movie 1', posterPath: 'poster1.jpg', rating: 8.0)],
      totalResults: 1,
      totalPages: 1,
    );

    test('should return search results when the internet is available', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockSearchRemoteDataSource.searchMovies(query, page))
          .thenAnswer((_) async => searchResultsModel);

      final result = await searchRepository.searchMovies(query, page);

      expect(result.isRight(), true);
      result.fold(
            (failure) => null,
            (searchResults) => expect(searchResults.items?.length, 1),
      );
      verify(() => mockSearchRemoteDataSource.searchMovies(query, page)).called(1);
    });

    test('should return ServerFailure when no internet connection', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await searchRepository.searchMovies(query, page);

      expect(result.isLeft(), true);
      result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (searchResults) => null,
      );
      verifyNever(() => mockSearchRemoteDataSource.searchMovies(query, page));
    });

    test('should return ServerFailure when the search fails', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockSearchRemoteDataSource.searchMovies(query, page))
          .thenThrow(ServerException('Search failed'));

      final result = await searchRepository.searchMovies(query, page);

      expect(result.isLeft(), true);
      result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (searchResults) => null,
      );
    });
  });
}

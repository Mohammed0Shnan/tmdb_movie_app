import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/features/search/data/datasources/search_remote_data_source.dart';
import 'package:tmdb_movie_app/core/errors/exceptions.dart';
import 'package:tmdb_movie_app/features/search/data/models/search_result_model.dart';

class MockSearchRemoteDataSource extends Mock implements SearchRemoteDataSourceImpl {}

void main() {
  late MockSearchRemoteDataSource mockSearchRemoteDataSource;

  setUp(() {
    mockSearchRemoteDataSource = MockSearchRemoteDataSource();
  });

  group('searchMovies', () {
    const query = 'Mo';
    const page = 1;

    final searchResultsModel = SearchResultsModel(
      items: [
        SearchResultModel(id: 1, title: 'Mo Test 1', posterPath: 'poster1.jpg', rating: 8.0),
        SearchResultModel(id: 2, title: 'Test Mo', posterPath: 'poster2.jpg', rating: 7.5),
        SearchResultModel(id: 3, title: 'Test Test', posterPath: 'poster3.jpg', rating: 9.0),
      ],
      totalResults: 3,
      totalPages: 1,
    );

    test('should return only search results that contain "MoMo" in the title', () async {
      when(() => mockSearchRemoteDataSource.searchMovies(query, page))
          .thenAnswer((_) async => searchResultsModel);

      final result = await mockSearchRemoteDataSource.searchMovies(query, page);

      final filteredResults = result.items?.where((item) => item.title.toLowerCase().contains(query.toLowerCase())).toList();

      print('Filtered Results:');
      filteredResults?.forEach((item) {
        print(item.title);
      });

      expect(filteredResults?.length, 2);

      for (var item in filteredResults!) {
        expect(item.title.toLowerCase().contains(query.toLowerCase()), true, reason: 'Title should contain "$query"');
      }
    });

    test('should throw ServerException when the response is unsuccessful', () async {
      when(() => mockSearchRemoteDataSource.searchMovies(query, page))
          .thenThrow(ServerException('Server error'));

      expect(
            () => mockSearchRemoteDataSource.searchMovies(query, page),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

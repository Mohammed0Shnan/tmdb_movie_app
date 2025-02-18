import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/core/usecases/usecase.dart';
import 'package:tmdb_movie_app/features/search/data/models/search_result_model.dart';
import 'package:tmdb_movie_app/features/search/domain/usecases/search_movies.dart';
import 'package:tmdb_movie_app/features/search/domain/repositories/search_repository.dart';
import 'package:tmdb_movie_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;
  late SearchMovies useCase;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    useCase = SearchMovies(mockSearchRepository);
  });

  group('searchMovies', () {
    const query = 'movie';
    const page = 1;

    final searchResultsModel = SearchResultsModel(
      items: [SearchResultModel(id: 1, title: 'Movie 1', posterPath: 'poster1.jpg', rating: 8.0)],
      totalResults: 1,
      totalPages: 1,
    );

    test('should return search results when the repository call is successful', () async {
      when(() => mockSearchRepository.searchMovies(query, page))
          .thenAnswer((_) async => Right(searchResultsModel));

      final result = await useCase(SearchParams(query: query, page: page));

      expect(result.isRight(), true);
      result.fold(
            (failure) => null,
            (searchResults) => expect(searchResults.items?.length, 1),
      );
      verify(() => mockSearchRepository.searchMovies(query, page)).called(1);
    });

    test('should return ServerFailure when the repository call fails', () async {
      when(() => mockSearchRepository.searchMovies(query, page))
          .thenAnswer((_) async => Left(ServerFailure('Error')));

      final result = await useCase(SearchParams(query: query, page: page));

      expect(result.isLeft(), true);
      result.fold(
            (failure) => expect(failure, isA<ServerFailure>()),
            (searchResults) => null,
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/core/usecases/usecase.dart';
import 'package:tmdb_movie_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:tmdb_movie_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:tmdb_movie_app/core/errors/failures.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';

import '../../../../test_utilities/mock_data.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetPopularMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetPopularMovies(mockMovieRepository);
  });

  const page = 1;

  final movieList =mockMoviesEntity ();

  setUpAll(() {
    registerFallbackValue(PageParams(page: page));
  });

  test('should return MoviesEntity from the repository', () async {
    when(() => mockMovieRepository.getPopularMovies(page))
        .thenAnswer((_) async => Right(movieList));

    final result = await useCase(PageParams(page: page));

    expect(result.isRight(), true);
    result.fold(
          (failure) => null,
          (movies) => expect(movies.items?.length, 2),
    );
    verify(() => mockMovieRepository.getPopularMovies(page)).called(1);
  });

  test('should return ServerFailure when repository call fails', () async {
    when(() => mockMovieRepository.getPopularMovies(page))
        .thenAnswer((_) async => Left(ServerFailure('Error')));
    final result = await useCase(PageParams(page: page));
    expect(result.isLeft(), true);
    result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (movies) => null,
    );
    verify(() => mockMovieRepository.getPopularMovies(page)).called(1);
  });
}

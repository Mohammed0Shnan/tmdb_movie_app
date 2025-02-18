import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tmdb_movie_app/core/usecases/usecase.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';
import 'package:tmdb_movie_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/movie_event.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/popular_movie_bloc.dart';

import '../../../test_utilities/mock_data.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late PopularMovieBloc popularMovieBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    registerFallbackValue(PageParams(page: 1));
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

  tearDown(() {
    popularMovieBloc.close();
  });

  group('PopularMovieBloc', () {
    final tMovies = mockMoviesEntity().items!;

    test('Initial state of PopularMovieBloc is MovieInitial', () {
      expect(popularMovieBloc.state, MovieInitial());
      expect(popularMovieBloc.currentPage, 1);
      expect(popularMovieBloc.allMovies, isEmpty);
      expect(popularMovieBloc.hasReachedMax, isFalse);
      expect(popularMovieBloc.isViewAll, isFalse);
    });
    blocTest<PopularMovieBloc, MovieState>(
      'emits [MovieLoading, MoviesLoaded] when GetPopularMoviesEvent is added',
      build: () {
        return popularMovieBloc;
      },

      act: (bloc) async {
        final movieList = MoviesEntity(
          items: tMovies,
          totalResult: 2,
          totalPages: 1,
        );

        when(() => mockGetPopularMovies.call(any()))
            .thenAnswer((_) async => Right(movieList));
        bloc.add(GetPopularMoviesEvent());
        await Future.delayed(const Duration(seconds: 1));
      },
      expect: () => [
        MovieLoading(),
        MoviesLoaded(movies: tMovies, currentPage: 1, totalPages: 1, totalResults: 2), // Then expect MoviesLoaded with the correct data
      ],
    );
  });
}

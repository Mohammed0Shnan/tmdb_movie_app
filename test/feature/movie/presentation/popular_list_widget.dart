
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/popular_movie_bloc.dart';
import 'package:tmdb_movie_app/features/movies/presentation/widgets/movie_card_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../test_utilities/mock_data.dart';
import 'popular_list_widget.mocks.dart';


@GenerateMocks([PopularMovieBloc])
void main() {
  group('MoviePopularHorizontalList Tests', () {
    late MockPopularMovieBloc mockBloc;

    setUp(() {
      mockBloc = MockPopularMovieBloc();

      when(mockBloc.stream).thenAnswer((_) => Stream.value(MovieLoading()));

      when(mockBloc.fetch()).thenReturn(MovieLoading());

      when(mockBloc.fetch()).thenAnswer((_) async => {});
    });


    testWidgets('should render movie card with correct data', (WidgetTester tester) async {
      final movie = mockPopularHList().first;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: movie),
        ),
      ));

      expect(find.text(movie.title), findsOneWidget);
      expect(find.text(movie.voteAverage.toString()), findsOneWidget);
      expect(find.byType(Hero), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    // testWidgets('should display MovieCards when state is MoviesLoaded', (WidgetTester tester) async {
    //   final movies = mockPopularHList();
    //   final loadedState = MoviesLoaded(
    //     movies: movies,
    //     currentPage: 1,
    //     totalPages: 1,
    //     totalResults: movies.length,
    //   );
    //
    //   when<MovieState>( mockBloc.state).thenReturn(loadedState);
    //   when<Stream<MovieState>>( mockBloc.stream).thenAnswer((_) => Stream<MovieState>.value(loadedState));
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: BlocProvider<PopularMovieBloc>.value(
    //         value: mockBloc,
    //         child: const MoviePopularHorizontalList(),
    //       ),
    //     ),
    //   );
    //
    //   await tester.pump();
    //
    //   verifyNever(() => mockBloc.fetch());
    //
    //   expect(find.byType(MovieCard), findsNWidgets(movies.length));
    //   expect(find.text('Popular Movies'), findsOneWidget);
    //   expect(find.text('View All'), findsOneWidget);
    // });
    //


  });

}
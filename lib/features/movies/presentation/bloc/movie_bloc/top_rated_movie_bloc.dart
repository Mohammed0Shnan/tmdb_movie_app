import 'package:tmdb_movie_app/features/movies/domain/usecases/get_top_rated_movies.dart';

import '../../../../../core/imports.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/movie.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class TopRatedMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies getTopRatedMovies;
  int currentPage = 1;
  List<Movie> allMovies = [];
  bool hasReachedMax = false;
  bool isViewAll = false;
  int maxCount =10;

  TopRatedMovieBloc({
    required this.getTopRatedMovies,
  }) : super(MovieInitial()) {
    on<GetTopRatedMoviesEvent>(_onGetTopRatedMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
  }

  fetch(){
    add(GetTopRatedMoviesEvent());
  }
  Future<void> _onGetTopRatedMovies(
      GetTopRatedMoviesEvent event,
      Emitter<MovieState> emit,
      ) async {
    if(!isViewAll && allMovies.length> maxCount){
      return;
    }
    emit(MovieLoading());

    final result = await getTopRatedMovies(PageParams(page: currentPage));

    result.fold(
          (failure) => emit(MovieError(failure.message)),
          (movies) {
        allMovies = movies.items!;
        emit(MoviesLoaded(
          movies: isViewAll ? allMovies : allMovies.take(maxCount).toList(),
          currentPage: currentPage,
          totalPages: movies.totalPages!,
          totalResults: movies.totalResult!,
        ));
        // _checkAndLoadMoreIfNeeded(emit,movies.totalResult!,movies.totalPages!);
        if (movies.totalResult == allMovies.length) {
          hasReachedMax = true;
        }
      },
    );
  }

  Future<void> _onLoadMoreMovies(
      LoadMoreMoviesEvent event,
      Emitter<MovieState> emit,
      ) async {
    if (hasReachedMax) return;

    final nextPage = currentPage + 1;

    final result = await getTopRatedMovies(PageParams(page: nextPage));

    result.fold(
          (failure) => emit(MovieError(failure.message)),
          (newMovies) {

        currentPage = nextPage;
        allMovies.addAll(newMovies.items!);
        emit(MoviesLoaded(
          movies: allMovies ,
          currentPage: currentPage,
          totalPages: newMovies.totalPages!,
          totalResults: newMovies.totalResult!,
        ));
        if (newMovies.totalResult == allMovies.length) {
          hasReachedMax = true;

        }

      },
    );
  }

  // void _checkAndLoadMoreIfNeeded(Emitter<MovieState> emit ,int totalResult ,int totalPages ) {
  //
  //   emit(MoviesLoaded(
  //     movies: isViewAll ? allMovies : allMovies.take(10).toList(),
  //     currentPage: currentPage,
  //     totalPages: totalPages,
  //     totalResults: totalResult,
  //   ));
  //   if (!isViewAll && allMovies.length < 10) {
  //     add(LoadMoreMoviesEvent());
  //   }
  //
  // }

  void switchToViewAll(bool isViewAllScreen) {
    isViewAll = isViewAllScreen;
    currentPage = 1;
    allMovies.clear();
    add(GetTopRatedMoviesEvent());
  }
}

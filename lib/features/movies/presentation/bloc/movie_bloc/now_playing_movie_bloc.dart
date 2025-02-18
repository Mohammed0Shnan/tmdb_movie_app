import '../../../../../core/imports.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class NowPlayingMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  int currentPage = 1;
  List<Movie> allMovies = [];
  bool hasReachedMax = false;
  bool isViewAll = false;
  int maxCount =10;
  NowPlayingMovieBloc({
    required this.getNowPlayingMovies,
  }) : super(MovieInitial()) {
    on<GetNowPlayingMoviesEvent>(_onGetNowPlayingMovies);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
  }
fetch(){
 add(GetNowPlayingMoviesEvent());
}

  Future<void> _onGetNowPlayingMovies(
      GetNowPlayingMoviesEvent event,
      Emitter<MovieState> emit,
      ) async {
    if(!isViewAll && allMovies.length> maxCount){
      return;
    }
    emit(MovieLoading());
    final result = await getNowPlayingMovies(PageParams(page: 1));

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
    final result = await getNowPlayingMovies(PageParams(page: nextPage));

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



  void switchToViewAll(bool isViewAllScreen) {
    isViewAll = isViewAllScreen;
    currentPage = 1;
    allMovies.clear();
    add(GetNowPlayingMoviesEvent());
  }
}

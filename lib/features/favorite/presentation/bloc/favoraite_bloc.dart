import '../../../../core/imports.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_favorite_movies.dart';
import '../../domain/usecases/toggle_favorite_movie.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteMovieBloc extends Bloc<FavoriteMovieEvent, FavoriteMovieState> {
  final ToggleFavoriteMovie toggleFavoriteMovie;
  final GetFavoriteMovies getFavoriteMovies;

  FavoriteMovieBloc({
    required this.toggleFavoriteMovie,
    required this.getFavoriteMovies,
  }) : super(FavoriteMoviesInitial()) {
    on<LoadFavoriteMoviesEvent>(_onLoadFavorites);
    on<ToggleFavoriteMovieEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
      LoadFavoriteMoviesEvent event, Emitter<FavoriteMovieState> emit) async {
    final result = await getFavoriteMovies(NoParams());
    result.fold(
          (failure) => emit(FavoriteMovieError('Failed to load favorites')),
          (movies) => emit(FavoriteMoviesLoaded(movies)),
    );
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteMovieEvent event, Emitter<FavoriteMovieState> emit) async {
    await toggleFavoriteMovie(FavoriteMovieParams(event.movie) );
    add(LoadFavoriteMoviesEvent());
  }
}


import '../../../../../core/imports.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_movie_details.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;

  MovieDetailsBloc({required this.getMovieDetails}) : super(MovieDetailsInitial()) {
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
  }

  Future<void> _onGetMovieDetails(
      GetMovieDetailsEvent event,
      Emitter<MovieDetailsState> emit,
      ) async {
    emit(MovieDetailsLoading());

    final result = await getMovieDetails(MovieParams(event.movieId));

    result.fold(
          (failure) => emit(MovieDetailsError(failure.message)),
          (movieDetail) => emit(MovieDetailsLoaded(movieDetail)),
    );
  }
}

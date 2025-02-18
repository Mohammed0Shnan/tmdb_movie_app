import '../../../../../core/imports.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_movie_video.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';


class MovieVideosBloc extends Bloc<MovieDetailsEvent, MovieDetailsState>  {
  final GetMovieVideos getMovieVideos;

  MovieVideosBloc({required this.getMovieVideos}) : super(MovieDetailsInitial()) {
    on<GetMovieVideosEvent>(_onGetMovieVideos);
  }

  Future<void> _onGetMovieVideos(
      GetMovieVideosEvent event,
      Emitter<MovieDetailsState> emit,
      ) async {
    emit(MovieDetailsLoading());

    final result = await getMovieVideos(MovieParams(event.movieId));

    result.fold(
          (failure) => emit(MovieDetailsError(failure.message)),
          (videos) => emit(MovieVideosLoaded(videos)),
    );
  }
}

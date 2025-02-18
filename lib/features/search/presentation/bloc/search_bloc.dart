
import 'package:tmdb_movie_app/features/search/presentation/bloc/search_events.dart';
import 'package:tmdb_movie_app/features/search/presentation/bloc/search_states.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/imports.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/usecases/search_movies.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  int currentPage = 1;
  List<SearchResult> allMovies = [];
  bool hasReachedMax = false;
  String currentQuery = '';

  SearchBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
    on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<SearchState> emit,
      ) async {
      if (event.query.isEmpty) {
        emit(SearchInitial());
        return;
      }

      currentPage = 1;
      allMovies.clear();
      hasReachedMax = false;
      currentQuery = event.query;
      emit(SearchLoading());
      final result = await searchMovies(
        SearchParams(query: event.query, page: currentPage),
      );
      result.fold(
            (failure) => emit(SearchError(_mapFailureToMessage(failure))),
            (movies) {
          allMovies = movies.items ?? [];
          emit(SearchLoaded(
            movies: allMovies,
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
  Future<void> _onLoadMoreSearchResults(
      LoadMoreSearchResults event,
      Emitter<SearchState> emit,
      ) async {
    if (hasReachedMax) return;

    final nextPage = currentPage + 1;
    final result = await searchMovies(
      SearchParams(query: currentQuery, page: nextPage),
    );

    result.fold(
          (failure) => emit(SearchError(_mapFailureToMessage(failure))),
          (newMovies) {
        if (newMovies.items == null || newMovies.items!.isEmpty) {
          hasReachedMax = true;
        } else {
          currentPage = nextPage;
          allMovies.addAll(newMovies.items!);
          hasReachedMax = currentPage >= (newMovies.totalPages ?? 1); // Check page limit
          emit(SearchLoaded(
            movies: allMovies,
            currentPage: nextPage,
            totalPages: newMovies.totalPages!,
            totalResults: newMovies.totalResult!,
          ));
        }
      },
    );
  }


  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    currentPage = 1;
    allMovies.clear();
    hasReachedMax = false;
    currentQuery = '';
    emit(SearchInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      default:
        return 'Unexpected error';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}


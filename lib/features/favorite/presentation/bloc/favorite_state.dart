import 'package:equatable/equatable.dart';

import '../../../movies/domain/entities/movie.dart';

abstract class FavoriteMovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteMoviesInitial extends FavoriteMovieState {}

class FavoriteMoviesLoaded extends FavoriteMovieState {
  final List<Movie> movies;
  FavoriteMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class FavoriteMovieError extends FavoriteMovieState {
  final String message;
  FavoriteMovieError(this.message);
}

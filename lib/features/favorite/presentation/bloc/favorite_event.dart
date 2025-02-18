import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoriteMovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleFavoriteMovieEvent extends FavoriteMovieEvent {
  final Movie movie;
  ToggleFavoriteMovieEvent(this.movie);
}

class LoadFavoriteMoviesEvent extends FavoriteMovieEvent {}

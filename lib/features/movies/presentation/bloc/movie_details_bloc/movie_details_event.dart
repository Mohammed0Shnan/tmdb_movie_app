import 'package:equatable/equatable.dart';

abstract class MovieDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;
  GetMovieDetailsEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class GetMovieVideosEvent extends MovieDetailsEvent {
  final int movieId;
  GetMovieVideosEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;
  final int totalPages ;
  final int totalResults ;
  final int currentPage ;

  MoviesLoaded( {required this.movies,required this.currentPage, required this.totalPages, required this.totalResults});

  @override
  List<Object> get props => [movies,totalPages,totalResults,currentPage];
}


class MovieError extends MovieState {
  final String message;
  MovieError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPopularMoviesEvent extends MovieEvent {}
class GetTopRatedMoviesEvent extends MovieEvent {}
class GetNowPlayingMoviesEvent extends MovieEvent {}

class LoadMoreMoviesEvent extends MovieEvent {}
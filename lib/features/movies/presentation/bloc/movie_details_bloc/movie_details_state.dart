import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_detail.dart';
import '../../../domain/entities/movie_video.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetail movieDetail;
  MovieDetailsLoaded(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  MovieDetailsError(this.message);

  @override
  List<Object> get props => [message];
}



class MovieVideosLoaded extends MovieDetailsState {
  final List<MovieVideo> videos;
  MovieVideosLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}






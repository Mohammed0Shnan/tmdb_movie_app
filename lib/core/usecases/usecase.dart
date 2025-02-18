import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';

import '../errors/failures.dart';


abstract class UseCase<Type, P extends Params> {
  Future<Either<Failure, Type>> call(P params);
}

abstract class Params extends Equatable {
  const Params();

  @override
  List<Object> get props => [];
}

class NoParams extends Params {
  const NoParams();
}

class PageParams extends Params {
  final int page;

  const PageParams({required this.page});

  @override
  List<Object> get props => [page];
}

class MovieParams extends Params {
  final int id;
  const MovieParams(this.id);

  @override
  List<Object> get props => [id];
}
class FavoriteMovieParams extends Params {
  final Movie movie;
  const FavoriteMovieParams(this.movie);

  @override
  List<Object> get props => [id];
}
class SearchParams extends Params {
  final String query;
  final int? page;

  const SearchParams({
    required this.query,
    this.page,
  });

  @override
  List<Object> get props => [query, page ?? 1];
}


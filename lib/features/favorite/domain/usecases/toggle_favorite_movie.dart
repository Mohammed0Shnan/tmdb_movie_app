
import 'package:dartz/dartz.dart';
import 'package:tmdb_movie_app/features/favorite/domain/repositories/favorite_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ToggleFavoriteMovie implements UseCase<void, FavoriteMovieParams> {
  final FavoriteRepository repository;

  ToggleFavoriteMovie(this.repository);

  @override
  Future<Either<Failure, void>> call(FavoriteMovieParams params) {
    return repository.toggleFavorite( params.movie );
  }
}


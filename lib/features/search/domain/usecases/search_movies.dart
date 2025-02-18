import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class SearchMovies implements UseCase<SearchResultsEntity, SearchParams> {
  final SearchRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure,SearchResultsEntity>> call(SearchParams params) {
    return repository.searchMovies(params.query,params.page!);
  }
}


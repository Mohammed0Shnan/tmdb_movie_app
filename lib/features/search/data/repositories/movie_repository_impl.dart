
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network.dart';
import '../../../movies/data/datasources/movie_local_data_source.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_result_model.dart';

class SearchRepositoryImpl implements SearchRepository {
final SearchRemoteDataSource remoteDataSource;
final NetworkInfo networkInfo;

SearchRepositoryImpl({
  required this.remoteDataSource,
  required this.networkInfo,
});

@override
Future<Either<Failure,SearchResultsModel>> searchMovies(String query,int page) async {
  try {
    if (await networkInfo.isConnected) {
      final movies = await remoteDataSource.searchMovies(query,page);
      return Right(movies);
    } else {
      return const Left(ServerFailure('No internet connection'));
    }
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}


}
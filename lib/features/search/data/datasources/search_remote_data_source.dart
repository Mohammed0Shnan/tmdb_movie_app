
import 'package:dio/dio.dart';

import '../../../../core/const/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {

  Future<SearchResultsModel> searchMovies(String query ,int page);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<SearchResultsModel> searchMovies(String query ,int page) async {
    try {
      final response = await client.get(
        '${ApiConstants.baseUrl}/search/movie',
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'language': 'en-US',
          'query': query,
          'page':page.toString()
        },
      );
        if (response != null && response['results'] != null) {
          return SearchResultsModel.fromMap({
            'results': response['results'],
            'total_results': response['total_results'],
            'total_pages': response['total_pages'],
          });
        } else {
          throw ServerException('Failed to fetch popular movies');
        }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.statusMessage ?? 'Failed to search movies',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}

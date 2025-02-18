// import 'dart:developer';
//
// import 'package:dio/dio.dart';
//
// import '../errors/exceptions.dart';
//
// class ApiClient {
//   final Dio _client;
//   final String token = "";
//   final String tag = 'ApiClient';
//
//   ApiClient._privateConstructor()
//       : _client = Dio(BaseOptions(
//     sendTimeout: Duration(milliseconds: 60000),
//     receiveTimeout: Duration(milliseconds: 60000),
//     connectTimeout: Duration(milliseconds: 60000),
//     followRedirects: false,
//     receiveDataWhenStatusError: true,
//   )) {
//     print('ApiClient Initialized');
//   }
//
//
//   // Singleton pattern to reuse Dio instance
//   static final ApiClient _instance = ApiClient._privateConstructor();
//
//
//   // Provide a method to get the singleton instance
//   static ApiClient get instance => _instance;
//
//   // Handle GET requests
//   Future<Map<String, dynamic>?> get(
//       String url, {
//         Map<String, String>? queryParameters = const {},
//         Map<String, String>? headers = const {},
//       }) async {
//     try {
//       print('Making GET request to $url');
//
//       if (headers != null && headers.isNotEmpty) {
//         if (headers['Authorization'] != null) {
//           _client.options.headers['Authorization'] = headers['Authorization'];
//         }
//       }
//
//       var response = await _client.get(
//         url,
//         queryParameters: queryParameters,
//       );
//
//       print('Response: ${response.data}');
//       return _processResponse(response);
//     } on DioError catch (e) {
//       log("DIO ERROR: ${e.toString()}");
//       return _handleError(e);
//     }
//   }
//
//   static Map<String, dynamic>? _processResponse(Response response) {
//     if (response.statusCode! >= 200 && response.statusCode! <= 300) {
//       return response.data;
//     } else if (response.statusCode == 500) {
//       throw ServerException('');
//     } else {
//       return null;
//     }
//   }
//
//   Map<String, dynamic>? _handleError(DioError e) {
//     if (e.response != null) {
//       return e.response!.data;
//     } else {
//       throw NetworkException('An unknown error occurred');
//     }
//   }
// }

import 'dart:developer';
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio client;
  final String token = "";
  final String tag = 'ApiClient';

  // Public constructor (no longer private)
  ApiClient({Dio? dio})
      : client = dio ?? Dio(BaseOptions(
    sendTimeout: Duration(milliseconds: 60000),
    receiveTimeout: Duration(milliseconds: 60000),
    connectTimeout: Duration(milliseconds: 60000),
    followRedirects: false,
    receiveDataWhenStatusError: true,
  ));

  // Handle GET requests
  Future<Map<String, dynamic>?> get(
      String url, {
        Map<String, String>? queryParameters = const {},
        Map<String, String>? headers = const {},
      }) async {
    try {
      print('Making GET request to $url');

      if (headers != null && headers.isNotEmpty) {
        if (headers['Authorization'] != null) {
          client.options.headers['Authorization'] = headers['Authorization'];
        }
      }

      var response = await client.get(
        url,
        queryParameters: queryParameters,
      );

      print('Response: ${response.data}');
      return _processResponse(response);
    } on DioException catch (e) {
      log("DIO ERROR: ${e.toString()}");
      return _handleError(e);
    }
  }

   Map<String, dynamic>? _processResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! <= 300) {
      return response.data;
    } else if (response.statusCode == 500) {
      throw ServerException('');
    } else {
      return null;
    }
  }

  Map<String, dynamic>? _handleError(DioError e) {
    if (e.response != null) {
      return e.response!.data;
    } else {
      throw NetworkException('An unknown error occurred');
    }
  }
}

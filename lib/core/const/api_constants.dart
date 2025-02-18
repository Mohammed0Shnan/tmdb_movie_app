
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static String get apiKey => dotenv.env['API_KEY']??'';

  // Movie Endpoints
  static const String popularMovies = '$baseUrl/movie/popular';
  static const String topRatedMovies = '$baseUrl/movie/top_rated';
  static const String nowPlayingMovies = '$baseUrl/movie/now_playing';
  static const String movieBaseUrl = '$baseUrl/movie';

  // Image Base URL
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
}

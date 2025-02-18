import 'package:tmdb_movie_app/features/movies/presentation/pages/home_page.dart';
import 'package:tmdb_movie_app/features/movies/presentation/pages/movie_details_page.dart';
import 'package:tmdb_movie_app/features/search/presentation/pages/search_page.dart';
import '../../features/movies/presentation/pages/all_movies.dart';
import '../imports.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String allMovies = '/allMovies';
  static const String movieDetails = '/movieDetails';
  static const String search = '/search';

 static Map<String, WidgetBuilder> routes = {
   AppRoutes.splash: (context) =>  SplashScreen(),
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.allMovies: (context) => const AllMoviesPage(),
    AppRoutes.movieDetails: (context) => const MovieDetailScreen(),
    AppRoutes.search: (context) => const SearchPage(),
  };
}


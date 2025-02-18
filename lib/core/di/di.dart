import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmdb_movie_app/core/network/http_client.dart';
import 'package:tmdb_movie_app/core/network/network.dart';
import 'package:tmdb_movie_app/core/storage/implementations/hive_movie_cache_storage.dart';
import 'package:tmdb_movie_app/core/storage/implementations/hive_movie_favorites_storage.dart';
import 'package:tmdb_movie_app/core/storage/interfaces/movie_cache_storage.dart';
import 'package:tmdb_movie_app/core/storage/interfaces/movie_favorites_storage.dart';
import 'package:tmdb_movie_app/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:tmdb_movie_app/features/favorite/presentation/bloc/favoraite_bloc.dart';
import 'package:tmdb_movie_app/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:tmdb_movie_app/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:tmdb_movie_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:tmdb_movie_app/features/movies/domain/repositories/movie_repository.dart';
import 'package:tmdb_movie_app/features/movies/domain/usecases/get_movie_details.dart';
import 'package:tmdb_movie_app/features/movies/domain/usecases/get_movie_video.dart';
import 'package:tmdb_movie_app/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/popular_movie_bloc.dart';
import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_details_bloc/movie_details_bloc.dart';
import 'package:tmdb_movie_app/features/search/data/repositories/movie_repository_impl.dart';
import '../../features/favorite/data/datasources/favorate_locale_data_source.dart';
import '../../features/favorite/data/repositories/favorite_repository_impl.dart';
import '../../features/favorite/domain/usecases/get_favorite_movies.dart';
import '../../features/favorite/domain/usecases/toggle_favorite_movie.dart';
import '../../features/movies/domain/usecases/get_now_playing_movies.dart';
import '../../features/movies/domain/usecases/get_top_rated_movies.dart';
import '../../features/movies/presentation/bloc/movie_bloc/now_playing_movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_bloc/top_rated_movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc/movie_videos_bloc.dart';
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_movies.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../storage/services/hive_service.dart';
import '../theme/repository/theme_repository.dart';
import '../theme/theme_bloc/theme_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  await _initCore();
  await _initStorage();
  await _initDataSources();
  _initRepositories();
  _initUseCases();
  _initBlocs();
}
/// **Initialize Core Dependencies**
 _initCore() async{

   di.registerLazySingleton<ApiClient>(() => ApiClient());
   di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl.instance);
 }

/// **Initialize Storage Layer**
Future<void> _initStorage() async {
  // Shared Pref
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register HiveService
  di.registerLazySingleton<HiveService>(() => HiveService());

  // Initialize Hive
  await di<HiveService>().init();

  try {
    final hiveService = di<HiveService>();
    final moviesBox = await hiveService.openMoviesBox();
    final favoritesBox = await hiveService.openFavoritesBox();

    // Register Hive boxes (OPTIONAL, but useful for debugging)
    di.registerSingleton<Box<Map<dynamic, dynamic>>>(moviesBox, instanceName: 'moviesBox');
    di.registerSingleton<Box<Map<dynamic, dynamic>>>(favoritesBox, instanceName: 'favoritesBox');

    // Register storage implementations
    di.registerLazySingleton<MovieCacheStorage>(
          () => HiveMovieCacheStorage(moviesBox: moviesBox),
    );

    di.registerLazySingleton<MovieFavoritesStorage>(
          () => HiveMovieFavoritesStorage(favoritesBox: favoritesBox),
    );

    print('core =========.  222');
  } catch (e) {
    throw Exception('Failed to open Hive boxes: $e');
  }
}

/// **Initialize Data Sources**
Future<void> _initDataSources() async {

  di.registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl(client: di<ApiClient>()),
  );
  di.registerLazySingleton<MovieLocalDataSource>(
        () => MovieLocalDataSourceImpl(
      movieStorage: di<MovieCacheStorage>(),

    ),  // Local data source
  );
  di.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(client: di<ApiClient>()),
  );
  di.registerLazySingleton<FavoriteMovieLocalDataSource>(
        () => FavoriteMovieLocalDataSourceImpl(    favoritesStorage: di<MovieFavoritesStorage>(),),
  );

}

/// **Initialize Repositories**
void _initRepositories() {
  di.registerLazySingleton<ThemeRepository>(()=> ThemeRepository(preferences: di<SharedPreferences>()));
  di.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: di<MovieRemoteDataSource>(),
      localDataSource: di<MovieLocalDataSource>(),
      networkInfo: di<NetworkInfo>(),
    ),  // Movie repository implementation
  );
  di.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(
      remoteDataSource: di<SearchRemoteDataSource>(),
      networkInfo: di<NetworkInfo>(),
    ),  // Movie repository implementation
  );
  di.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(
          localDataSource: di<FavoriteMovieLocalDataSource>()
    ),
  );

}

/// **Initialize Use Cases**
void _initUseCases() {
  di.registerLazySingleton(() => GetPopularMovies(di<MovieRepository>()));  // Use case for popular movies
  di.registerLazySingleton(() => GetMovieDetails(di<MovieRepository>()));  // Use case for movie details
  di.registerLazySingleton(() => GetTopRatedMovies(di<MovieRepository>()));  // Use case for top-rated movies
  di.registerLazySingleton(() => GetMovieVideos(di<MovieRepository>()));  // Use case for top-rated movies
  di.registerLazySingleton(() => GetNowPlayingMovies(di<MovieRepository>()));  // Use case for top-rated movies
  di.registerLazySingleton(() => SearchMovies(di<SearchRepository>()));  // Use case for top-rated movies
  di.registerLazySingleton(() => GetFavoriteMovies(di<FavoriteRepository>()));  // Use case for top-rated movies
  di.registerLazySingleton(() => ToggleFavoriteMovie(di<FavoriteRepository>()));  // Use case for top-rated movies

}

/// **Initialize Blocs**
void _initBlocs() {


  di.registerFactory(() => ThemeBloc(themeRepository: di<ThemeRepository>()));

  di.registerFactory(
        () => PopularMovieBloc(
      getPopularMovies: di<GetPopularMovies>(),
    ),
  );  // Bloc for fetching popular movies

  di.registerFactory(
        () => TopRatedMovieBloc(
      getTopRatedMovies: di<GetTopRatedMovies>(),
    ),
  );

  di.registerFactory(
        () => NowPlayingMovieBloc(
          getNowPlayingMovies: di<GetNowPlayingMovies>(),
    ),
  );
  di.registerFactory(
        () => MovieDetailsBloc(
      getMovieDetails:  di<GetMovieDetails>(),
    ),
  );
  di.registerFactory(
        () => MovieVideosBloc(
          getMovieVideos: di<GetMovieVideos>(),
    ),
  );
  di.registerFactory(
        () => SearchBloc(
          searchMovies: di<SearchMovies>(),
    ),
  );
  di.registerFactory(
        () => FavoriteMovieBloc(
          getFavoriteMovies: di<GetFavoriteMovies>(),
      toggleFavoriteMovie: di<ToggleFavoriteMovie>(),
    ),
  );

}

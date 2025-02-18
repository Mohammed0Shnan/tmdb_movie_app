import 'package:tmdb_movie_app/core/imports.dart';
import 'package:tmdb_movie_app/core/theme/theme_bloc/theme_bloc.dart';
import 'package:tmdb_movie_app/core/di/di.dart' as di;
import 'package:tmdb_movie_app/features/favorite/presentation/bloc/favoraite_bloc.dart';
import '../../features/movies/presentation/bloc/movie_bloc/now_playing_movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_bloc/popular_movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_bloc/top_rated_movie_bloc.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc/movie_details_bloc.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc/movie_videos_bloc.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';

class BlocInitializers extends StatelessWidget {
  const BlocInitializers({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(
          create: (context) => di.di<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (context) => di.di<TopRatedMovieBloc>(),
        ),BlocProvider(
          create: (context) => di.di<NowPlayingMovieBloc>(),
        ),
        BlocProvider(
          create: (context) => di.di<MovieDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.di<MovieVideosBloc>(),
        ),

        BlocProvider(
          create: (context) => di.di<SearchBloc>(),
        )
        ,
        BlocProvider(
          create: (context) => di.di<ThemeBloc>(),
        ),
        BlocProvider(
          create: (context) => di.di<FavoriteMovieBloc>(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => di.di<ThemeBloc>()
          ),
        ],
        child: child,
      ),
    );
  }
}



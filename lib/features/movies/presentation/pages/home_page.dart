import 'package:tmdb_movie_app/features/movies/presentation/bloc/movie_bloc/popular_movie_bloc.dart';
import 'package:tmdb_movie_app/features/movies/presentation/widgets/home_app_bar.dart';
import '../../../../core/imports.dart';
import '../../../search/presentation/widgets/home_search_box.dart';
import '../bloc/movie_bloc/now_playing_movie_bloc.dart';
import '../bloc/movie_bloc/top_rated_movie_bloc.dart';
import '../widgets/horizontal_now_playing_movie_list.dart';
import '../widgets/horizontal_popular_movie_list.dart';
import '../widgets/horizontal_top_rated_movies_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PopularMovieBloc>().fetch();
          context.read<TopRatedMovieBloc>().fetch();
          context.read<NowPlayingMovieBloc>().fetch();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const HomeSearchBox(),
              const SizedBox(height: 16),
              const MoviePopularHorizontalList(),
              const SizedBox(height: 16),
              MovieTopRatedMovieHorizontalList(),
              const SizedBox(height: 16),
              MovieNowPlayingHorizontalList(),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

}

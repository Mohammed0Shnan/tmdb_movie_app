import 'package:tmdb_movie_app/core/animations/animation_slide_transition.dart';
import 'package:tmdb_movie_app/features/movies/presentation/widgets/shimmer.dart';
import '../../../../core/imports.dart';
import '../../../../core/resources/padding_manager.dart';
import '../bloc/movie_bloc/top_rated_movie_bloc.dart';
import '../pages/all_movies.dart';
import 'error_message_widget.dart';
import 'movie_card_widget.dart';
import '../bloc/movie_bloc/movie_event.dart';
import '../bloc/movie_bloc/movie_state.dart';
import 'no_more_data_to_load_widget.dart';
import 'package:auto_animated/auto_animated.dart';
class MovieTopRatedMovieHorizontalList extends StatefulWidget {
  const MovieTopRatedMovieHorizontalList({super.key});

  @override
  State<MovieTopRatedMovieHorizontalList> createState() => _MovieTopRatedMovieHorizontalListState();
}

class _MovieTopRatedMovieHorizontalListState extends State<MovieTopRatedMovieHorizontalList> {
  late final ScrollController _scrollController ;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    fetch();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  fetch() {
    if (mounted) {
      context.read<TopRatedMovieBloc>().fetch();
    }
  }
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {

   fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Rated Movies',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  context.read<TopRatedMovieBloc>().switchToViewAll(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllMoviesPage(),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Movie List
        SizedBox(
          height: 250.sp,
          child: BlocBuilder<TopRatedMovieBloc, MovieState>(

            builder: (context, state) {
              if (state is MoviesLoaded) {
                return LiveList(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: PaddingManager.mainHorizonalSpace),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.movies.length + 1,
                  itemBuilder: animationItemBuilder((index){
                    if (index < state.movies.length) {
                      return MovieCard(
                        movie: state.movies[index],
                      );
                    } else {
                      if (state.currentPage == state.totalPages ||
                          state.totalPages == 1 ) {
                        return const NoMoreDataToLoadWidget();
                      }
                      else if( state.movies.length==10){
                        return const SizedBox.shrink();
                      }
                      else {
                        return const MovieCardShimmer();
                      }
                    }
                  })

                );
              } else if (state is MovieError) {
                return ErrorMessageWidget(
                  message: 'Error',
                  onRetry: () {},
                );
              } else {
                return MovieListShimmer();
              }
            },
          ),
        ),
      ],
    );
  }
}

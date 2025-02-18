import 'package:tmdb_movie_app/core/animations/animation_slide_transition.dart';
import 'package:tmdb_movie_app/features/movies/presentation/widgets/shimmer.dart';
import '../../../../core/imports.dart';
import '../../../../core/resources/padding_manager.dart';
import '../pages/all_movies.dart';
import 'error_message_widget.dart';
import 'movie_card_widget.dart';
import '../bloc/movie_bloc/popular_movie_bloc.dart';
import '../bloc/movie_bloc/movie_state.dart';
import 'no_more_data_to_load_widget.dart';
import 'package:auto_animated/auto_animated.dart';

class MoviePopularHorizontalList extends StatefulWidget {
  const MoviePopularHorizontalList({super.key});

  @override
  State<MoviePopularHorizontalList> createState() =>
      _MoviePopularHorizontalListState();
}

class _MoviePopularHorizontalListState
    extends State<MoviePopularHorizontalList> {
  late final ScrollController _scrollController;

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
      context.read<PopularMovieBloc>().fetch();
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
                'Popular Movies',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  context.read<PopularMovieBloc>().switchToViewAll(true);
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
          child: BlocBuilder<PopularMovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MoviesLoaded) {
                return LiveList(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: PaddingManager.mainHorizonalSpace),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.movies.length + 1,
                    itemBuilder: animationItemBuilder((index) {
                      if (index < state.movies.length) {
                        return MovieCard(
                          movie: state.movies[index],
                        );
                      } else {
                        if (state.currentPage == state.totalPages ||
                            state.totalPages == 1) {
                          return const NoMoreDataToLoadWidget();
                        }
                        else if( state.movies.length==10){
                          return const SizedBox.shrink();
                        }
                        else {
                          return const MovieCardShimmer();
                        }
                      }
                    }));
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

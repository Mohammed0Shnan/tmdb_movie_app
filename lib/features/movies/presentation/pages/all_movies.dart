import 'package:tmdb_movie_app/features/movies/presentation/widgets/shimmer.dart';
import '../../../../core/imports.dart';
import '../bloc/movie_bloc/popular_movie_bloc.dart';
import '../bloc/movie_bloc/movie_event.dart';
import '../bloc/movie_bloc/movie_state.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/movie_card_widget.dart';
import '../widgets/no_more_data_to_load_widget.dart';

class AllMoviesPage extends StatefulWidget {
  const AllMoviesPage({super.key});

  @override
  State<AllMoviesPage> createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {

      context.read<PopularMovieBloc>().add(LoadMoreMoviesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop,r) {
        if (didPop) {
          context.read<PopularMovieBloc>().switchToViewAll(false);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "All Movies",),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<PopularMovieBloc, MovieState>(

                builder: (context, state) {
                  if (state is MoviesLoaded) {
                    return AnimationLimiter(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: .6,
                        ),
                        itemCount: state.movies.length + 2,
                        itemBuilder: (context, index) {
                          if (index < state.movies.length) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              columnCount: 2, // Two columns in the grid
                              child: ScaleAnimation(
                                scale: 0.8,
                                child: FadeInAnimation(
                                  child: MovieCard(
                                    movie: state.movies[index],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            if (state.currentPage == state.totalPages ||
                                state.totalPages == 1) {
                              return const NoMoreDataToLoadWidget();
                            } else  {
                              return MovieGridShimmer(position: index,);
                            }
                          }
                        },
                      ),
                    );
                  } else if (state is MovieError) {
                    return ErrorMessageWidget(
                      message: 'Error',
                      onRetry: () {},
                    );
                  } else {
                    return MovieGridShimmer(position: 0);
                  }
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movie_app/features/movies/domain/entities/movie.dart';
import '../../../../../core/imports.dart';
import '../../../../core/theme/dark_theme.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../favorite/presentation/bloc/favoraite_bloc.dart';
import '../../../favorite/presentation/bloc/favorite_event.dart';
import '../../../favorite/presentation/bloc/favorite_state.dart';
import '../../domain/entities/movie_detail.dart';
import '../bloc/movie_details_bloc/movie_details_bloc.dart';
import '../bloc/movie_details_bloc/movie_details_event.dart';
import '../bloc/movie_details_bloc/movie_details_state.dart';
import '../bloc/movie_details_bloc/movie_videos_bloc.dart';
import '../widgets/movie_trailer_bottom_sheet_widget.dart';
import '../widgets/shimmer.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({
    super.key,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late int movieId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      movieId = args;
      context.read<MovieDetailsBloc>().add(GetMovieDetailsEvent(movieId));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const MovieDetailShimmer();
          } else if (state is MovieDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<MovieDetailsBloc>()
                          .add(GetMovieDetailsEvent(movieId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is MovieDetailsLoaded) {
            return _buildContent(context, state.movieDetail);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieDetail movie) {
    return CustomScrollView(
      slivers: [
        buildAppBar(context, movie),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie.tagline.isNotEmpty) ...[
                  Text(
                    movie.tagline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                _buildRatingAndInfo(movie),
                const SizedBox(height: 16),
                _buildOverview(movie),
                const SizedBox(height: 16),
                _buildGenres(movie),
                const SizedBox(height: 16),
                _buildProductionCompanies(movie),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget buildAppBar(BuildContext context, MovieDetail movie) {


    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
            ),
            Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showTrailerBottomSheet(context, movie.id),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Watch Trailer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white70),
        ),
      ),
      actions: [
        BlocBuilder<FavoriteMovieBloc, FavoriteMovieState>(
          builder: (context, state) {
            bool isFavorite = (state is FavoriteMoviesLoaded) &&
                state.movies.any((favMovie) => favMovie.id == movie.id);

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 40,
              ),
              onPressed: () {
                context
                    .read<FavoriteMovieBloc>()
                    .add(ToggleFavoriteMovieEvent(movie.toMovie()));
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRatingAndInfo(MovieDetail movie) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          movie.voteAverage.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 16),
        Text("${movie.runtime} min"),
      ],
    );
  }

  Widget _buildOverview(MovieDetail movie) {
    return Text(
      movie.overview,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildGenres(MovieDetail movie) {
    return Wrap(
      spacing: 8.0,
      children: movie.genres
          .map((genre) => Chip(label: Text(genre.name)))
          .toList(),
    );
  }

  Widget _buildProductionCompanies(MovieDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Production Companies",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8.0,
          children: movie.productionCompanies
              .map((company) => Chip(label: Text(company.name)))
              .toList(),
        ),
      ],
    );
  }

  void _showTrailerBottomSheet(BuildContext context, int movieId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => di<MovieVideosBloc>()
            ..add(GetMovieVideosEvent(movieId)), // Trigger API call
          child: const MovieTrailerBottomSheet(),
        );      },
    );
  }

}

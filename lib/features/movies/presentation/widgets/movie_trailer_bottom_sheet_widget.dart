import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/imports.dart';
import '../bloc/movie_details_bloc/movie_details_state.dart';
import '../bloc/movie_details_bloc/movie_videos_bloc.dart';

class MovieTrailerBottomSheet extends StatefulWidget {
  const MovieTrailerBottomSheet({super.key});

  @override
  State<MovieTrailerBottomSheet> createState() => _MovieTrailerBottomSheetState();
}

class _MovieTrailerBottomSheetState extends State<MovieTrailerBottomSheet> {
  late final PageController _pageController;
  YoutubePlayerController? _youtubeController;
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _initializeVideoController(String videoKey) {
    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final containerHeight = isLandscape
                ? constraints.maxHeight * 0.9
                : constraints.maxHeight * 0.6;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: screenSize.height * 0.02,
              ),
              height: containerHeight,
              child: BlocBuilder<MovieVideosBloc, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieDetailsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is MovieVideosLoaded) {
                    final videos = state.videos.where((video) => video.site == 'YouTube').toList();

                    if (videos.isEmpty) {
                      return const Center(
                        child: Text(
                          "No videos available",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (_youtubeController == null) {
                      _initializeVideoController(videos[0].key);
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: videos.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentVideoIndex = index;
                                  _initializeVideoController(videos[index].key);
                                });
                              },
                              itemBuilder: (context, index) {
                                if (index == _currentVideoIndex && _youtubeController != null) {
                                  return AspectRatio(
                                    aspectRatio: 16 / 9, // Standard video aspect ratio
                                    child: YoutubePlayer(
                                      controller: _youtubeController!,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: Colors.red,
                                      progressColors: const ProgressBarColors(
                                        playedColor: Colors.red,
                                        handleColor: Colors.redAccent,
                                      ),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.02,
                            vertical: screenSize.height * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: _currentVideoIndex > 0
                                    ? () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                                    : null,
                              ),
                              Text(
                                'Video ${_currentVideoIndex + 1}/${videos.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.04,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                                onPressed: _currentVideoIndex < videos.length - 1
                                    ? () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        SizedBox(
                          width: screenSize.width * 0.4,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: const Text("Close"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.015,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

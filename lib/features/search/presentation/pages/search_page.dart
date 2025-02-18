import '../../../../core/imports.dart';
import '../../../../core/resources/padding_manager.dart';
import '../../../movies/presentation/widgets/error_message_widget.dart';
import '../../../movies/presentation/widgets/no_more_data_to_load_widget.dart';
import '../../../movies/presentation/widgets/shimmer.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_events.dart';
import '../bloc/search_states.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/movie_search_card.dart';
import '../widgets/search_result.dart';
import '../widgets/shimmers.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late final ScrollController _scrollController ;
  late final FocusNode _searchFocusNode;
  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<SearchBloc>().add(ClearSearch());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent
      ) {
      context.read<SearchBloc>().add(LoadMoreSearchResults());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(focusNode: _searchFocusNode,),
            ),
            Expanded(
              child: BlocConsumer<SearchBloc, SearchState>(
                listener: (context,state){

                },

                builder: (context, state) {
                  if (state is SearchLoaded) {
print('current page : ${state.currentPage} , TotalPAges : ${state.totalPages}');
                    return ListView.builder(
                      itemCount: state.movies.length + 1,
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: PaddingManager.mainHorizonalSpace),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        print('+++++++++++++');
                        if (index < state.movies.length) {
                          final movie = state.movies[index];
                          return MovieSearchCard(movie: movie);
                        } else {
                          if (state.currentPage == state.totalPages ||
                              state.totalPages == 0) {
                            return const NoMoreDataToLoadWidget();
                          } else {
                            return const MovieSearchCardShimmer();
                          }
                        }


                      },
                    );
                  } else if (state is SearchError) {
                    return ErrorMessageWidget(
                      message: state.message,
                      onRetry: () {
                        // context.read<SearchBloc>().add(event)
                      },
                    );
                  } else if(state is SearchInitial) {
                    return Center(child: Text('Search'),);

                  }else{
                    return MovieSearchListShimmer();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

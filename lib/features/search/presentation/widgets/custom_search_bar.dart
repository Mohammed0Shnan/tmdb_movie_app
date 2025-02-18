import '../../../../core/imports.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_events.dart';

class CustomSearchBar extends StatefulWidget {
  final FocusNode? focusNode;
  const CustomSearchBar({super.key, this.focusNode});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(query));
      } else {
        context.read<SearchBloc>().add(ClearSearch());
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Expanded(
          child: TextField(
            focusNode: widget.focusNode,
            controller: _controller, // Assign the controller
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear(); // Clear the text field
                  context.read<SearchBloc>().add(ClearSearch());
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ],
    );
  }
}

import 'package:tmdb_movie_app/features/movies/presentation/widgets/theme_toggle_button.dart';
import '../../../../core/imports.dart';
import '../../../../core/theme/dark_theme.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../../core/theme/theme_bloc/theme_state.dart';

class HomeAppBar extends StatelessWidget  implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkTheme = state.themeMode == ThemeMode.dark;

        final theme = isDarkTheme ? DarkTheme.theme : LightTheme.theme;

        return AppBar(
         automaticallyImplyLeading: false,
          title: Text(
            'TMDB Movie App',
            style: TextStyle(fontSize: 20,),
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 4.0,
          actions: const [
            ThemeToggleButton(),
            SizedBox(width: 8),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}

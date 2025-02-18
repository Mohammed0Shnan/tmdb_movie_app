
import '../../../../core/imports.dart';
import '../../../../core/theme/constants/theme_constant.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../../core/theme/theme_bloc/theme_event.dart';
import '../../../../core/theme/theme_bloc/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              key: ValueKey(state.themeMode),
            ),
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(
              ThemeSwitchEvent(
                themeId: state.themeMode == ThemeMode.dark
                    ? ThemeConstants.lightTheme
                    : ThemeConstants.darkTheme,
              ),
            );
          },
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/dark_theme.dart';
import '../../../../core/theme/theme_bloc/theme_bloc.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/theme/theme_bloc/theme_state.dart'; // Assuming you have the LightTheme

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkTheme = state.themeMode == ThemeMode.dark;

        final theme = isDarkTheme ? DarkTheme.theme : LightTheme.theme;

        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            title,

            style: theme.textTheme.titleLarge,
          ),
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 4.0,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Default AppBar height
}

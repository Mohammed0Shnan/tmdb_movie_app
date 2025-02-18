import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tmdb_movie_app/core/di/di.dart' as di;
import 'package:tmdb_movie_app/core/imports.dart';
import 'package:tmdb_movie_app/core/theme/theme_bloc/theme_state.dart';
import 'core/di/bloc_initializers.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await di.init();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocInitializers(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                showPerformanceOverlay: false,
                debugShowCheckedModeBanner: false,
                title: 'TMDB Movie App',
                onGenerateRoute: (settings) =>
                    onGenerateRoute(settings, AppRoutes.routes),
                theme: AppTheme.getTheme(themeState.themeMode),
                themeMode: themeState.themeMode,
                builder: (context, child) {
                  return child!;
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_movie_app/core/theme/theme_bloc/theme_event.dart';
import 'package:tmdb_movie_app/core/theme/theme_bloc/theme_state.dart';

import '../constants/theme_constant.dart';
import '../repository/theme_repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository})
      : super(const ThemeState(themeMode: ThemeMode.system)) {

    on<InitialThemeSetEvent>(_onInitialThemeSet);
    on<ThemeSwitchEvent>(_onThemeSwitch);
  }

  ThemeMode _getThemeModeFromId(int themeId) {
    switch (themeId) {
      case ThemeConstants.lightTheme:
        return ThemeMode.light;
      case ThemeConstants.darkTheme:
        return ThemeMode.dark;
      case ThemeConstants.systemTheme:
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _onInitialThemeSet(
      InitialThemeSetEvent event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      final themeMode = await themeRepository.getThemeMode();
      log('Initial theme mode: $themeMode');
      emit(ThemeState(themeMode: _getThemeModeFromId(themeMode)));
    } catch (e) {
      log('Error loading theme: $e');
      emit(const ThemeState(themeMode: ThemeMode.system));
    }
  }

  Future<void> _onThemeSwitch(
      ThemeSwitchEvent event,
      Emitter<ThemeState> emit,
      ) async {
    try {
      final newThemeMode = _getThemeModeFromId(event.themeId);
      await themeRepository.saveThemeMode(event.themeId);
      log('Theme switched to: ${event.themeId}');
      emit(ThemeState(themeMode: newThemeMode));
    } catch (e) {
      log('Error switching theme: $e');
      // Keep the current state in case of error
    }
  }
}
import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class InitialThemeSetEvent extends ThemeEvent {
  const InitialThemeSetEvent();
}

class ThemeSwitchEvent extends ThemeEvent {
  final int themeId;

  const ThemeSwitchEvent({required this.themeId});

  @override
  List<Object?> get props => [themeId];
}

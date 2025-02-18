import 'package:hive/hive.dart';

import '../../errors/exceptions.dart';
import '../interfaces/movie_favorites_storage.dart';

class HiveMovieFavoritesStorage implements MovieFavoritesStorage {
  final Box<Map<dynamic, dynamic>> favoritesBox;
  static const String FAVORITES_KEY = 'favorites';

  HiveMovieFavoritesStorage({required this.favoritesBox});

  @override
  Future<Map<dynamic, dynamic>?> getFavorites() async {
    try {
      return favoritesBox.get(FAVORITES_KEY);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> saveFavorites(Map<dynamic, dynamic> favorites) async {
    try {
      await favoritesBox.put(FAVORITES_KEY, favorites);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
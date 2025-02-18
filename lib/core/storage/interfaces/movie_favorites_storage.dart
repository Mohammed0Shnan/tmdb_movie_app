abstract class MovieFavoritesStorage {
  Future<Map<dynamic, dynamic>?> getFavorites();
  Future<void> saveFavorites(Map<dynamic, dynamic> favorites);
}
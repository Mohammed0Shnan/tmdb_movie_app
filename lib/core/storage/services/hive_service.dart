import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Future<Box<Map<String, dynamic>>> openMoviesBox() async {
    return await Hive.openBox<Map<String, dynamic>>('moviesBox');
  }

  Future<Box<Map<dynamic, dynamic>>> openFavoritesBox() async {
    return await Hive.openBox<Map<dynamic, dynamic>>('favoritesBox');
  }
}

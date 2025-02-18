import '../../domain/entities/movie_video.dart';

class MovieVideoModel extends MovieVideo  {
  const MovieVideoModel({
    required super.id,
    required super.key,
    required super.name,
    required super.site,
    required super.type,
  });

  factory MovieVideoModel.fromJson(Map<String, dynamic> json) {
    return MovieVideoModel(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      site: json['site'],
      type: json['type'],
    );
  }

  static List<MovieVideoModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MovieVideoModel.fromJson(json)).toList();
  }
}

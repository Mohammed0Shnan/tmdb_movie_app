import '../../domain/entities/movie.dart';

class MoviesModel extends MoviesEntity  {
  MoviesModel({
    List<MovieModel>? items,
    int? totalResults,
    int? totalPages,
  }) : super(
    items: items,
    totalResult: totalResults,
    totalPages: totalPages,
  );

  factory MoviesModel.fromMap(Map<String, dynamic> map) {
    return MoviesModel(
      items: map['results'] != null
          ? (map['results'] as List)
          .map((e) => MovieModel.fromJson(e))
          .toList()
          : [],
      totalResults: map['total_results'] ?? 0,
      totalPages: map['total_pages'] ?? 0,
    );
  }
}

class MovieModel extends Movie  {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genreIds,
    required super.adult,
    required super.originalLanguage,
    required super.originalTitle,
    required super.popularity,
    required super.video,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] as num).toDouble(),
      video: json['video'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genre_ids': genreIds,
      'adult': adult,
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'popularity': popularity,
      'video': video,
    };
  }
}

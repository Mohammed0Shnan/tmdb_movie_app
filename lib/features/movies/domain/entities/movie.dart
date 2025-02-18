import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class MoviesEntity extends Equatable {
  final List<Movie>? items;
  final int? totalResult;
  final int? totalPages;
  const MoviesEntity({
    required this.items,
    this.totalResult,
    this.totalPages,
  });

  @override
  List<Object?> get props => [items, totalResult, totalPages];
}

@HiveType(typeId: 0)


@HiveType(typeId: 0) // Unique Type ID for Hive
class Movie extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String backdropPath;

  @HiveField(5)
  final double voteAverage;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  final List<int> genreIds;

  @HiveField(8)
  final bool adult;

  @HiveField(9)
  final String originalLanguage;

  @HiveField(10)
  final String originalTitle;

  @HiveField(11)
  final double popularity;

  @HiveField(12)
  final bool video;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
    required this.video,
  });

  @override
  List<Object> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    releaseDate,
    genreIds,
    adult,
    originalLanguage,
    originalTitle,
    popularity,
    video,
  ];
}


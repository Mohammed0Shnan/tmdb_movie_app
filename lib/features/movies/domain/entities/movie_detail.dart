
import 'package:equatable/equatable.dart';

import 'movie.dart';

class MovieDetail extends Equatable {
  final bool adult;
  final String backdropPath;
  final int budget;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<ProductionCompany> productionCompanies;
  final String releaseDate;
  final int runtime;
  final String status;
  final String tagline;
  final String title;
  final double voteAverage;
  final int voteCount;

  const MovieDetail({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.releaseDate,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    budget,
    genres,
    homepage,
    id,
    overview,
    popularity,
    posterPath,
    productionCompanies,
    releaseDate,
    runtime,
    status,
    tagline,
    title,
    voteAverage,
    voteCount,
  ];
}

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class ProductionCompany extends Equatable {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  const ProductionCompany({
    required this.id,
    this.logoPath,
    required this.name,
    required this.originCountry,
  });

  @override
  List<Object?> get props => [id, logoPath, name, originCountry];
}

extension MovieDetailExtension on MovieDetail {
  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      genreIds: genres.map((genre) => genre.id).toList(),
      adult: adult,
      originalLanguage: "",
      originalTitle: title,
      popularity: popularity,
      video: false,
    );
  }
}


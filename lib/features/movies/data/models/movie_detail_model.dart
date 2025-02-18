import 'package:equatable/equatable.dart';

import '../../domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail  with EquatableMixin{
  const MovieDetailModel({
    required super.adult,
    required super.backdropPath,
    required super.budget,
    required super.genres,
    required super.homepage,
    required super.id,
    required super.overview,
    required super.popularity,
    required super.posterPath,
    required super.productionCompanies,
    required super.releaseDate,
    required super.runtime,
    required super.status,
    required super.tagline,
    required super.title,
    required super.voteAverage,
    required super.voteCount,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'] ?? '',
      budget: json['budget'] ?? 0,
      genres: (json['genres'] as List?)
          ?.map((genre) => GenreModel.fromJson(genre))
          .toList() ??
          [],
      homepage: json['homepage'] ?? '',
      id: json['id'] ?? 0,
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'] ?? '',
      productionCompanies: (json['production_companies'] as List?)
          ?.map((company) => ProductionCompanyModel.fromJson(company))
          .toList() ??
          [],
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      title: json['title'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'budget': budget,
      'genres': genres.map((genre) => (genre as GenreModel).toJson()).toList(),
      'homepage': homepage,
      'id': id,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'production_companies': productionCompanies
          .map((company) => (company as ProductionCompanyModel).toJson())
          .toList(),
      'release_date': releaseDate,
      'runtime': runtime,
      'status': status,
      'tagline': tagline,
      'title': title,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}

class GenreModel extends Genre {
  const GenreModel({
    required super.id,
    required super.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ProductionCompanyModel extends ProductionCompany {
  const ProductionCompanyModel({
    required super.id,
    required super.logoPath,
    required super.name,
    required super.originCountry,
  });

  factory ProductionCompanyModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompanyModel(
      id: json['id'] ?? 0,
      logoPath: json['logo_path'],
      name: json['name'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo_path': logoPath,
      'name': name,
      'origin_country': originCountry,
    };
  }
}
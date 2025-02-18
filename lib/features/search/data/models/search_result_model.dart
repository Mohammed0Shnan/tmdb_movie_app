import 'package:equatable/equatable.dart';

import '../../domain/entities/search_result.dart';



class SearchResultsModel extends SearchResultsEntity with EquatableMixin {
  SearchResultsModel({
    List<SearchResultModel>? items,
    int? totalResults,
    int? totalPages,
  }) : super(
    items: items,
    totalResult: totalResults,
    totalPages: totalPages,
  );

  factory SearchResultsModel.fromMap(Map<String, dynamic> map) {
    return SearchResultsModel(
      items: map['results'] != null
          ? (map['results'] as List)
          .map((e) => SearchResultModel.fromJson(e))
          .toList()
          : [],
      totalResults: map['total_results'] ?? 0,
      totalPages: map['total_pages'] ?? 0,
    );
  }
}




class SearchResultModel extends SearchResult {
  const SearchResultModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.rating,

  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'],
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': rating,

    };
  }
}
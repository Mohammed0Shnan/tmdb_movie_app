import 'package:equatable/equatable.dart';




class SearchResultsEntity extends Equatable {
  final List<SearchResult>? items;
  final int? totalResult;
  final int? totalPages;
  const SearchResultsEntity({
    required this.items,
    this.totalResult,
    this.totalPages,
  });

  @override
  List<Object?> get props => [items, totalResult, totalPages];
}




class SearchResult extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final double rating;

  const SearchResult({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
  });

  @override
  List<Object?> get props => [id,title,posterPath,rating];
}
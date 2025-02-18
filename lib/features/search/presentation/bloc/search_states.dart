import 'package:equatable/equatable.dart';

import '../../domain/entities/search_result.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchResult> movies;
  final int currentPage;
  final int totalPages;
  final int totalResults;

   SearchLoaded({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
  });

  @override
  List<Object> get props => [
    movies,
    currentPage,
    totalPages,
    totalResults,
  ];
}
class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}
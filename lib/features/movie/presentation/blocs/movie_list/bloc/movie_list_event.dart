part of 'movie_list_bloc.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesEvent extends MovieListEvent {}

class SearchMoviesEvent extends MovieListEvent {
  final String query;

  const SearchMoviesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class ToggleFavouriteEvent extends MovieListEvent {
  final Movie movie;

  const ToggleFavouriteEvent({required this.movie});

  @override
  List<Object> get props => [movie];
}

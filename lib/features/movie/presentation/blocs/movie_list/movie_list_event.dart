part of 'movie_list_bloc.dart';

sealed class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class LoadMoviesEvent extends MovieListEvent {}

class LoadFavoritesEvent extends MovieListEvent {}

class SearchMoviesEvent extends MovieListEvent {
  final String query;

  const SearchMoviesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleViewEvent extends MovieListEvent {
  final bool showFavorites;

  const ToggleViewEvent(this.showFavorites);

  @override
  List<Object> get props => [showFavorites];
}

class UpdateMovieListEvent extends MovieListEvent {
  final Movie updatedMovie;

  const UpdateMovieListEvent(this.updatedMovie);

  @override
  List<Object> get props => [updatedMovie];
}

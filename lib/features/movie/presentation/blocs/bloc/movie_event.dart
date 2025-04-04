part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesEvent extends MovieEvent {}

class GetMovieDetailEvent extends MovieEvent {
  final int movieId;

  const GetMovieDetailEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class SearchMoviesEvent extends MovieEvent {
  final String query;

  const SearchMoviesEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFavoriteEvent extends MovieEvent {
  final Movie movie;

  const ToggleFavoriteEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

part of 'movie_details_bloc.dart';

sealed class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  const LoadMovieDetailsEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class ToggleFavoriteEvent extends MovieDetailsEvent {
  final Movie movie;

  const ToggleFavoriteEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

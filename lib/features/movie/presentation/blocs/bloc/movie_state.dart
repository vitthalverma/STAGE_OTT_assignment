part of 'movie_bloc.dart';

sealed class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

final class MovieInitial extends MovieState {}

final class MovieLoading extends MovieState {}

final class MoviesLoaded extends MovieState {
  final List<Movie> movies;

  const MoviesLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

final class MovieError extends MovieState {
  final String errMsg;

  const MovieError({required this.errMsg});

  @override
  List<Object> get props => [errMsg];
}

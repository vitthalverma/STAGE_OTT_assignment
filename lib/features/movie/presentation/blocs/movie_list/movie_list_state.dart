part of 'movie_list_bloc.dart';

sealed class MovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {
  final List<Movie> movies;
  final bool showFavorites;

  MovieListLoaded({
    required this.movies,
    this.showFavorites = false,
  });

  @override
  List<Object?> get props => [movies, showFavorites];

  MovieListLoaded copyWith({
    List<Movie>? movies,
    bool? showFavorites,
  }) {
    return MovieListLoaded(
      movies: movies ?? this.movies,
      showFavorites: showFavorites ?? this.showFavorites,
    );
  }
}

class MovieListError extends MovieListState {
  final String message;

  MovieListError(this.message);

  @override
  List<Object?> get props => [message];
}

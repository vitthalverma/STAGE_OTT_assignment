part of 'movie_details_bloc.dart';

sealed class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object> get props => [];
}

final class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;

  const MovieDetailsLoaded(this.movie);

  @override
  List<Object> get props => [movie];

  MovieDetailsLoaded copyWith({
    Movie? movie,
  }) {
    return MovieDetailsLoaded(
      movie ?? this.movie,
    );
  }
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  const MovieDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

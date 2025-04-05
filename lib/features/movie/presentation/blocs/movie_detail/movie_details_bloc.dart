import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movie_details.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetailsUseCase;
  final ToggleFavorite toggleFavoriteUseCase;

  MovieDetailsBloc({
    required this.getMovieDetailsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(MovieDetailsInitial()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());
    final result = await getMovieDetailsUseCase(event.movieId);

    result.fold(
      (failure) => emit(MovieDetailsError(failure.message)),
      (movie) => emit(MovieDetailsLoaded(movie)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieDetailsLoaded) {
      final result = await toggleFavoriteUseCase(event.movie);

      result.fold(
        (failure) => emit(MovieDetailsError(failure.message)),
        (isFavorite) {
          final updatedMovie =
              currentState.movie.copyWith(isFavorite: isFavorite);
          emit(currentState.copyWith(movie: updatedMovie));
        },
      );
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/search_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies getMovies;
  final SearchMovies searchMovies;
  final ToggleFavorite toggleFavorite;
  MovieBloc(this.getMovies, this.searchMovies, this.toggleFavorite)
      : super(MovieInitial()) {
    on<GetMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getMovies(NoParams());
      result.fold(
        (failure) => emit(MovieError(errMsg: failure.message)),
        (movies) => emit(MoviesLoaded(movies: movies)),
      );
    });

    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await searchMovies(event.query);
      result.fold(
        (failure) => emit(MovieError(errMsg: failure.message)),
        (movies) => emit(MoviesLoaded(movies: movies)),
      );
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      final currentState = state;
      if (currentState is MoviesLoaded) {
        final result = await toggleFavorite(event.movie);
        result.fold(
          (failure) => emit(MovieError(errMsg: failure.message)),
          (_) {
            final updatedMovie = event.movie.copyWith(
              isFavorite: !event.movie.isFavorite,
            );
            final updatedMovies = currentState.movies.map((movie) {
              return movie.id == updatedMovie.id ? updatedMovie : movie;
            }).toList();
            emit(MoviesLoaded(movies: updatedMovies));
          },
        );
      }
    });
  }
}

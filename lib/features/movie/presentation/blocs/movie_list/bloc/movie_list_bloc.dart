import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/search_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';
part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetMovies getMovies;
  final SearchMovies searchMovies;
  final ToggleFavorite toggleFavorite;

  MovieListBloc(this.getMovies, this.searchMovies, this.toggleFavorite)
      : super(MovieListInitial()) {
    on<GetMoviesEvent>((event, emit) async {
      emit(MovieListLoading());
      final result = await getMovies(NoParams());
      result.fold(
        (failure) => emit(MovieListError(errMsg: failure.message)),
        (movies) => emit(MovieListLoaded(movies: movies)),
      );
    });

    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieListLoading());
      final result = await searchMovies(event.query);
      result.fold(
        (failure) => emit(MovieListError(errMsg: failure.message)),
        (movies) => emit(MovieListLoaded(movies: movies)),
      );
    });

    on<ToggleFavouriteEvent>((event, emit) async {
      final currentState = state;
      if (currentState is MovieListLoaded) {
        final result = await toggleFavorite(event.movie);
        result.fold(
          (failure) => emit(MovieListError(errMsg: failure.message)),
          (_) {
            final updatedMovie = event.movie.copyWith(
              isFavorite: !event.movie.isFavorite,
            );
            final updatedMovies = currentState.movies.map((movie) {
              return movie.id == updatedMovie.id ? updatedMovie : movie;
            }).toList();
            emit(MovieListLoaded(movies: updatedMovies));
          },
        );
      }
    });
  }
}

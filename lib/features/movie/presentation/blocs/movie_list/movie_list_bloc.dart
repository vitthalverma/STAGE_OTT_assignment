import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/core/usecase/core_usecase.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_favourite_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/get_movies.dart';
import 'package:stage_assignment/features/movie/domain/usecases/search_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetMovies getMoviesUseCase;
  final GetFavouriteMovies getFavoriteMoviesUseCase;
  final SearchMovies searchMoviesUseCase;

  MovieListBloc({
    required this.getMoviesUseCase,
    required this.getFavoriteMoviesUseCase,
    required this.searchMoviesUseCase,
  }) : super(MovieListInitial()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<SearchMoviesEvent>(_onSearchMovies);
    on<ToggleViewEvent>(_onToggleView);
    on<UpdateMovieListEvent>(_onUpdateMovieList);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    final result = await getMoviesUseCase(NoParams());

    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MovieListLoaded(movies: movies)),
    );
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    final result = await getFavoriteMoviesUseCase(NoParams());

    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MovieListLoaded(movies: movies, showFavorites: true)),
    );
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());

    if (event.query.isEmpty) {
      add(LoadMoviesEvent());
      return;
    }

    final result = await searchMoviesUseCase(event.query);

    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) => emit(MovieListLoaded(movies: movies)),
    );
  }

  void _onToggleView(
    ToggleViewEvent event,
    Emitter<MovieListState> emit,
  ) {
    if (event.showFavorites) {
      add(LoadFavoritesEvent());
    } else {
      add(LoadMoviesEvent());
    }
  }

  void _onUpdateMovieList(
    UpdateMovieListEvent event,
    Emitter<MovieListState> emit,
  ) {
    final currentState = state;
    if (currentState is MovieListLoaded) {
      final updatedMovies = currentState.movies.map((movie) {
        if (movie.id == event.updatedMovie.id) {
          return event.updatedMovie;
        }
        return movie;
      }).toList();

      emit(currentState.copyWith(movies: updatedMovies));
    }
  }
}

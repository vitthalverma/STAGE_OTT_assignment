import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/movie_list_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/error_message.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/search_field.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          BlocBuilder<MovieListBloc, MovieListState>(
            builder: (context, state) {
              if (state is MovieListLoaded) {
                return IconButton(
                  icon: Icon(
                    state.showFavorites
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  onPressed: () {
                    context.read<MovieListBloc>().add(
                          ToggleViewEvent(!state.showFavorites),
                        );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchField(),
          ),
          Expanded(
            child: BlocBuilder<MovieListBloc, MovieListState>(
              builder: (context, state) {
                if (state is MovieListInitial || state is MovieListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieListLoaded) {
                  if (state.movies.isEmpty) {
                    return Center(
                      child: Text(
                        state.showFavorites
                            ? 'No favorite movies yet'
                            : 'No movies found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }
                  return MovieGrid(movies: state.movies);
                } else if (state is MovieListError) {
                  return ErrorMessage(
                    message: state.message,
                    onRetry: () =>
                        context.read<MovieListBloc>().add(LoadMoviesEvent()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

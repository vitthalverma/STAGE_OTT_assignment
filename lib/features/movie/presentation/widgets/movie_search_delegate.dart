import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid.dart';

import '../blocs/bloc/movie_bloc.dart';

class MovieSearchDelegate extends SearchDelegate {
  final MovieBloc movieBloc;

  MovieSearchDelegate({required this.movieBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    movieBloc.add(SearchMoviesEvent(query));
    return BlocBuilder<MovieBloc, MovieState>(
      bloc: movieBloc,
      builder: (context, state) {
        if (state is MovieInitial || state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MoviesLoaded) {
          return MovieGrid(movies: state.movies);
        } else if (state is MovieError) {
          return Center(child: Text(state.errMsg));
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void close(BuildContext context, result) {
    movieBloc.add(GetMoviesEvent());
    super.close(context, result);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

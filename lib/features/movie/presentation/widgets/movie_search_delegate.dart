import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/bloc/movie_list_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid.dart';

class MovieSearchDelegate extends SearchDelegate {
  final MovieListBloc movieListBloc;

  MovieSearchDelegate({required this.movieListBloc});

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
    movieListBloc.add(SearchMoviesEvent(query: query));
    return BlocBuilder<MovieListBloc, MovieListState>(
      bloc: movieListBloc,
      builder: (context, state) {
        if (state is MovieListInitial || state is MovieListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieListLoaded) {
          return MovieGrid(movies: state.movies);
        } else if (state is MovieListError) {
          return Center(child: Text(state.errMsg));
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void close(BuildContext context, result) {
    movieListBloc.add(GetMoviesEvent());
    super.close(context, result);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

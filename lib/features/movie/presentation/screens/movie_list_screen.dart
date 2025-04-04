import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/bloc/movie_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_search_delegate.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  movieBloc: context.read<MovieBloc>(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MoviesLoaded) {
            return MovieGrid(movies: state.movies);
          } else if (state is MovieError) {
            return Center(child: Text(state.errMsg));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

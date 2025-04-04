import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/bloc/movie_list_bloc.dart';
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
                  movieListBloc: context.read<MovieListBloc>(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          if (state is MovieListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieListLoaded) {
            return MovieGrid(movies: state.movies);
          } else if (state is MovieListError) {
            return Center(child: Text(state.errMsg));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

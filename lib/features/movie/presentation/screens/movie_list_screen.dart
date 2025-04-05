import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_search_delegate.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  bool showFavoritesOnly = false;
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(GetMoviesEvent());
  }

  void _toggleFavorites() {
    setState(() {
      showFavoritesOnly = !showFavoritesOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleFavorites,
            icon: Icon(
                showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
          ),
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
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MoviesLoaded) {
            final moviesToShow = showFavoritesOnly
                ? state.movies.where((m) => m.isFavorite).toList()
                : state.movies;
            if (moviesToShow.isEmpty) {
              return const Center(child: Text('No movies to show'));
            }
            return MovieGrid(movies: moviesToShow);
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

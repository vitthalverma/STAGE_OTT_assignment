import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/movie_list_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/screens/movie_detail_screen.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/movie_grid_item.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;

  const MovieGrid({super.key, required this.movies});

  void _navigateToDetails(BuildContext context, Movie movie) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );

    if (result != null && result is Movie) {
      context.read<MovieListBloc>().add(UpdateMovieListEvent(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieGridItem(
          movie: movie,
          onTap: () => _navigateToDetails(context, movie),
          onFavoriteToggle: (updatedMovie) {
            context
                .read<MovieListBloc>()
                .add(UpdateMovieListEvent(updatedMovie));
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/bloc/movie_bloc.dart';
import '../../domain/entities/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie initialMovie;
  const MovieDetailScreen({super.key, required this.initialMovie});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        final currentMovie = state is MoviesLoaded
            ? state.movies.firstWhere(
                (m) => m.id == initialMovie.id,
                orElse: () => initialMovie,
              )
            : initialMovie;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, currentMovie),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMovieDetails(context, currentMovie),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, Movie movie) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            movie.backdropPath.isNotEmpty
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                Icons.movie,
                                size: 60,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            movie.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: movie.isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            context.read<MovieBloc>().add(ToggleFavoriteEvent(movie));
          },
        ),
      ],
    );
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(
                movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: movie.isFavorite ? Colors.red : null,
              ),
              label: Text(
                movie.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                context.read<MovieBloc>().add(ToggleFavoriteEvent(movie));
              },
            ),
          ),
        ],
      ),
    );
  }
}

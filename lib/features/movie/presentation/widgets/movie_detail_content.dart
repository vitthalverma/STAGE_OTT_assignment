import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/presentation/bloc/movie_bloc.dart';

class MovieDetailContent extends StatelessWidget {
  final Movie movie;

  const MovieDetailContent({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                context.read<MovieBloc>().add(ToggleFavoriteEvent(movie));
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movie.releaseDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

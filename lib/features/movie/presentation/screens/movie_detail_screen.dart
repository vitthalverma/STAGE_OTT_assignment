import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_detail/movie_details_bloc.dart';
import 'package:stage_assignment/features/movie/presentation/widgets/error_message.dart';
import '../../domain/entities/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<MovieDetailsBloc>()
        .add(LoadMovieDetailsEvent(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
        listener: (context, state) {
          if (state is MovieDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MovieDetailsInitial || state is MovieDetailsLoading) {
            return const CircularProgressIndicator();
          } else if (state is MovieDetailsLoaded) {
            return _buildDetails(context, state.movie);
          } else if (state is MovieDetailsError) {
            return ErrorMessage(
              message: state.message,
              onRetry: () => context.read<MovieDetailsBloc>().add(
                    LoadMovieDetailsEvent(widget.movie.id),
                  ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, Movie movie) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, movie);
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: movie.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context
                      .read<MovieDetailsBloc>()
                      .add(ToggleFavoriteEvent(movie));
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
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Overview',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

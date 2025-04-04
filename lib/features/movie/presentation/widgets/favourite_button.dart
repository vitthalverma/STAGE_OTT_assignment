import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/presentation/blocs/movie_list/bloc/movie_list_bloc.dart';

class FavoriteButton extends StatelessWidget {
  final Movie movie;

  const FavoriteButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MovieListBloc>().add(ToggleFavouriteEvent(movie: movie));
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(
          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
          size: 20,
        ),
      ),
    );
  }
}

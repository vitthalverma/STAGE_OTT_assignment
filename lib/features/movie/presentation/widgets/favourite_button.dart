import 'package:flutter/material.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';
import 'package:stage_assignment/injection_container.dart';

class FavoriteButton extends StatefulWidget {
  final Movie movie;
  final Function(Movie) onFavoriteToggle;

  const FavoriteButton({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.movie.isFavorite != widget.movie.isFavorite) {
      setState(() {
        _isFavorite = widget.movie.isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _toggleFavorite,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _toggleFavorite() {
    sl<ToggleFavorite>()(widget.movie).then((result) {
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (isFavorite) {
          setState(() {
            _isFavorite = isFavorite;
          });
          widget
              .onFavoriteToggle(widget.movie.copyWith(isFavorite: isFavorite));
        },
      );
    });
  }
}

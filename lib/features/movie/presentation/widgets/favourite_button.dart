import 'package:flutter/material.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/usecases/toggle_favourite.dart';
import 'package:stage_assignment/injection_container.dart';

class FavoriteButton extends StatefulWidget {
  final Movie movie;
  final Function(Movie) onFavoriteToggle;

  const FavoriteButton({
    Key? key,
    required this.movie,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  @override
  void didUpdateWidget(FavoriteButton oldWidget) {
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
        borderRadius: BorderRadius.circular(20.0),
        onTap: _isLoading ? null : _toggleFavorite,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                  size: 24.0,
                ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await sl<ToggleFavorite>()(widget.movie);

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

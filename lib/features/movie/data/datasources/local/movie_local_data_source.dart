import 'package:hive/hive.dart';
import 'package:stage_assignment/core/errors/exceptions.dart';
import 'package:stage_assignment/features/movie/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<bool> toggleFavorite(MovieModel movie);
  Future<List<MovieModel>> getFavoriteMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box<MovieModel> box;

  MovieLocalDataSourceImpl(this.box);

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get favorites: ${e.toString()}');
    }
  }

  @override
  Future<bool> toggleFavorite(MovieModel movie) async {
    try {
      if (box.containsKey(movie.id)) {
        await box.delete(movie.id);
        return false;
      } else {
        await box.put(movie.id, movie.copyWith(isFavorite: true));
        return true;
      }
    } catch (e) {
      throw CacheException('Failed to toggle favorites: ${e.toString()}');
    }
  }
}

import 'package:hive/hive.dart';
import 'package:stage_assignment/core/errors/exceptions.dart';
import 'package:stage_assignment/features/movie/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<void> toggleFavorite(MovieModel movie);
  Future<List<MovieModel>> getFavoriteMovies();
  Future<void> init();
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
  Future<void> init() async {
    try {
      if (!box.isOpen) {
        await Hive.openBox<MovieModel>('favorite_movies');
      }
    } catch (e) {
      throw CacheException('Failed to initialize Hive: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(MovieModel movie) async {
    try {
      if (box.containsKey(movie.id)) {
        await box.delete(movie.id);
      } else {
        await box.put(movie.id, movie.copyWith(isFavorite: true));
      }
    } catch (e) {
      throw CacheException('Failed to toggle favorites: ${e.toString()}');
    }
  }
}

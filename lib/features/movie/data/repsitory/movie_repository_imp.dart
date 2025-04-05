import 'package:fpdart/fpdart.dart';
import 'package:stage_assignment/core/errors/exceptions.dart';
import 'package:stage_assignment/core/errors/failures.dart';
import 'package:stage_assignment/core/network/network_info.dart';
import 'package:stage_assignment/features/movie/data/datasources/local/movie_local_data_source.dart';
import 'package:stage_assignment/features/movie/data/datasources/remote/movie_remote_data_source.dart';
import 'package:stage_assignment/features/movie/data/models/movie_model.dart';
import 'package:stage_assignment/features/movie/domain/entities/movie.dart';
import 'package:stage_assignment/features/movie/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieLocalDataSource localDataSource;
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  MovieRepositoryImpl(
      this.localDataSource, this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<Movie>>> getMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getMovies();
        final localFavMovies = await localDataSource.getFavoriteMovies();
        final mergedMovies = remoteMovies.map((movie) {
          final isFavorite = localFavMovies.any((fav) => fav.id == movie.id);
          return movie.copyWith(isFavorite: isFavorite);
        }).toList();
        return right(mergedMovies.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } else {
      final favorites = await localDataSource.getFavoriteMovies();
      return right(favorites.map((movie) => movie.toEntity()).toList());
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      final favorites = await localDataSource.getFavoriteMovies();
      return right(favorites.map((movie) => movie.toEntity()).toList());
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final movie = await remoteDataSource.getMovieDetails(id);
        final favorites = await localDataSource.getFavoriteMovies();
        final isFavorite = favorites.any((fav) => fav.id == movie.id);
        return right(movie.copyWith(isFavorite: isFavorite).toEntity());
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } else {
      return left(const NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<void> initFavorites() async {
    await localDataSource.init();
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.searchMovies(query);
        final favorites = await localDataSource.getFavoriteMovies();
        final mergedMovies = movies.map((movie) {
          final isFavorite = favorites.any((fav) => fav.id == movie.id);
          return movie.copyWith(isFavorite: isFavorite);
        }).toList();
        return right(mergedMovies.map((movie) => movie.toEntity()).toList());
      } on ServerException catch (e) {
        return left(ServerFailure(e.message));
      }
    } else {
      final favorites = await localDataSource.getFavoriteMovies();
      return right(favorites.map((movie) => movie.toEntity()).toList());
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Movie movie) async {
    try {
      final movieModel = MovieModel.fromEntity(movie);
      await localDataSource.toggleFavorite(movieModel);
      return right(null);
    } on CacheException catch (e) {
      return left(CacheFailure(e.message));
    }
  }
}
